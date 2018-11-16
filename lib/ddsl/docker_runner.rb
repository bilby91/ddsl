# frozen_string_literal: true

require 'json'
require 'docker-api'
require_relative './mappable'

module DDSL
  class DockerRunner
    include DDSL::Mappable

    class RunExitCodeError < StandardError; end

    TRANSLATIONS = {
      'build' => {
        'dockerfile' => 'dockerfile',
        'build_args' => 'buildargs',
        'tags' => 't'
      },
      'run' => {
        'image' => 'Image',
        'cmd' => 'Cmd'
      }
    }.freeze

    TRANSFORMATIONS = {
      'build' => {
        'buildargs' => ->(x) { JSON.dump(x) }
      },
      'run' => {
        'Cmd' => ->(x) { x.split(' ') }
      }
    }.freeze

    attr_reader :io

    def initialize(io = $stdout)
      @io = io
    end

    def build(builds)
      builds.map do |b|
        build_image_with_logs(b) do |log|
          io.puts log
        end
      end
    end

    def run(runs)
      statuses = runs.map do |r|
        begin
          run_container_with_logs(r) do |log|
            io.puts log
          end
        rescue Docker::Error::ClientError => e
          raise RunExitCodeError, e.message
        end
      end
    end

    def get_image(id)
      Docker::Image.get(id)
    end

    #
    # Build a new image based on given specs yielding io
    #
    # @param [Hash] build_options
    # @param [Proc] &block
    #
    # @return [Hash]
    #
    private def build_image_with_logs(build_options)
      Docker::Image.build_from_dir(build_options['context'], mapped_build_options(build_options)) do |v|
        if (log = JSON.parse(v)) && log.key?('stream')
          yield log['stream']
        end
      end
    end

    #
    # Run a new container based on given specs yielding io
    #
    # @param [Hash] run_options
    # @param [Proc] &block
    #
    # @return [Hash]
    #
    private def run_container_with_logs(run_options)
      container = Docker::Container.create(mapped_run_options(run_options))

      container.streaming_logs(stderr: true, stdout: true, logs: true, follow: true) do |_stream, chunk|
        yield chunk
      end

      container.start
      container.wait(10)
    end

    #
    # Map build options for `Docker` module
    #
    # @param [Hash] run_options
    #
    # @return [Hash]
    #
    private def mapped_build_options(build_options)
      transform_options(
        translate_options(build_options, TRANSLATIONS['build']),
        TRANSFORMATIONS['build']
      )
    end

    #
    # Map run options for `Docker` module
    #
    # @param [Hash] run_options
    #
    # @return [Hash]
    #
    private def mapped_run_options(run_options)
      transform_options(
        translate_options(run_options, TRANSLATIONS['run']),
        TRANSFORMATIONS['run']
      )
    end
  end
end
