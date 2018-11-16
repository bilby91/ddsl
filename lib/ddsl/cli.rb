# frozen_string_literal: true

require 'commander'
require 'clamp'

require_relative './parser'
require_relative './docker_runner'

module DDSL
  class CLI < Clamp::Command
    option '--config', 'CONFIG', 'Configuration file path'

    subcommand 'build', 'Build the docker image associated with the project' do
      parameter 'NAME ...', 'name of the build', required: true, attribute_name: :names

      def execute
        docker_runner.build(search_targets!('builds'))
      end
    end

    subcommand 'run', 'Run a docker container or docker-compose service' do
      parameter 'NAME ...', 'name of the run', required: true, attribute_name: :names

      def execute
        docker_runner.run(search_targets!('runs'))
      end
    end

    def docker_runner
      @docker_runner ||= DockerRunner.new
    end

    def search_targets!(type)
      command_targets = targets(type)
      raise Clamp::UsageError.new('invalid NAME given', type) unless command_targets.count == names.count

      command_targets
    end

    def targets(type)
      parsed_config[type].select { |item| names.include? item['name'] }
    end

    def config_path
      @config_path ||= config || '.ddsl.yml'
    end

    def parsed_config
      @parsed_config ||= DDSL::Parser.new.parse(config_path)
    end
  end
end
