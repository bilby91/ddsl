# frozen_string_literal: true

require 'clamp'

require_relative './parser'
require_relative './shell'
require_relative './command'

module DDSL
  class CLI < Clamp::Command
    option '--config', 'CONFIG', 'Configuration file path'

    subcommand 'build', 'Build the docker image associated with the project' do
      parameter 'NAME ...', 'name of the build', required: true, attribute_name: :names

      def execute
        with_builder(search_targets!('builds')) do |runner, spec|
          begin
            runner.run(spec)
          rescue DDSL::Shell::ExitStatusError
            $stdout.puts 'Build failed.'
          end
        end
      end
    end

    subcommand 'run', 'Run a docker container or docker-compose service' do
      parameter 'NAME ...', 'name of the run', required: true, attribute_name: :names

      def execute
        with_runner(search_targets!('runs')) do |runner, spec|
          begin
            runner.run(spec)
          rescue DDSL::Shell::ExitStatusError
            $stdout.puts 'Run failed.'
          end
        end
      end
    end

    private def with_builder(builds)
      builds.map do |b|
        yield(builder_for_type(b['type']), b)
      end
    end

    private def with_runner(runs)
      runs.map do |r|
        yield(runner_for_type(r['type']), r)
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

    private def search_targets!(type)
      command_targets = targets(type)
      raise Clamp::UsageError.new('invalid NAME given', type) unless command_targets.count == names.count

      command_targets
    end

    private def targets(type)
      parsed_config[type].select { |item| names.include? item['name'] }
    end

    private def config_path
      @config_path ||= config || '.ddsl.yml'
    end

    private def parsed_config
      @parsed_config ||= DDSL::Parser.new.parse(config_path)
    end
  end
end
