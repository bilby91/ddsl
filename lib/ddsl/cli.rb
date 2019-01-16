# frozen_string_literal: true

require 'clamp'

require_relative './parser'

DDSL::Parser.new.parse(".ddsl.yml")

require_relative './variable_injector'
require_relative './shell'
require_relative './command'

module DDSL
  class CLI < Clamp::Command
    option '--config', 'CONFIG', 'Configuration file path'

    subcommand 'build', 'Build the docker image associated with the project' do
      parameter 'NAME ...', 'name of the build', required: true, attribute_name: :names

      def execute
        with_command('builds') do |command, spec|
          begin
            command.run(spec)
          rescue DDSL::Shell::ExitStatusError
            $stdout.puts 'Build failed.'
            exit(-1)
          end
        end
      end
    end

    subcommand 'run', 'Run a docker container or docker-compose service' do
      parameter 'NAME ...', 'name of the run', required: true, attribute_name: :names

      def execute
        with_command('runs') do |command, spec|
          begin
            command.run(spec)
          rescue DDSL::Shell::ExitStatusError
            $stdout.puts 'Run failed.'
            exit(-1)
          end
        end
      end
    end

    private def with_command(command_type)
      collection = search_targets!(command_type)

      login_if_needed

      collection.map do |x|
        yield(command_class(command_type, x['type']), x)
      end
    end

    private def command_class(command, type)
      case command
      when 'builds'
        builder_for_type(type)
      when 'runs'
        runner_for_type(type)
      end
    end

    private def runner_for_type(type)
      case type
      when 'docker'
        Command::Docker::Run.new
      when 'docker-compose'
        Command::DockerCompose::Run.new
      end
    end

    private def builder_for_type(type)
      case type
      when 'docker'
        Command::Docker::Build.new
      when 'docker-compose'
        Command::DockerCompose::Build.new
      end
    end

    private def login_if_needed
      parsed_config['registries'].each do |r|
        Command::Docker::Login.new.run(r) if need_login?(r)
      end
    end

    private def need_login?(registry)
      !registry['use_cache'] || (registry['use_cache'] && !cached_docker_auth?(registry['url']))
    end

    private def cached_docker_auth?(host)
      parsed_docker_config['auths'].any? do |url, _|
        URI.parse(url).host == URI.parse(host).host
      end
    end

    private def search_targets!(type)
      command_targets = targets(type)
      raise Clamp::UsageError.new('invalid NAME given', type) unless command_targets.count == names.count

      command_targets
    end

    private def targets(type)
      parsed_config[type].select { |item| names.include? item['name'] }
    end

    private def parsed_config
      @parsed_config ||= DDSL::VariableInjector.new(ENV).inject(
        DDSL::Parser.new.parse(config_path)
      )
    rescue DDSL::SchemaParser::InvalidError => e
      $stdout.puts e.message

      exit(-1) 
    end

    private def parsed_docker_config
      return { 'auths' => [] } unless File.exist?(docker_config_path)

      @parsed_docker_config ||= JSON.parse(
        File.read(docker_config_path)
      )
    end

    private def config_path
      @config_path ||= config || '.ddsl.yml'
    end

    private def docker_config_path
      @docker_config_path ||= File.join(home_path, '.docker', 'config.json')
    end

    private def home_path
      %w[HOME HOMEPATH].map { |e| ENV[e] }.compact.first
    end
  end
end
