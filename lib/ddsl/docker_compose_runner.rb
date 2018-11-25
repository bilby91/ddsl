# frozen_string_literal: true

require 'docker/compose'

module DDSL
  class DockerComposeRunner
    include DDSL::Mappable
    class RunExitCodeError < StandardError; end

    TRANSLATIONS = {
      'run' => {
        'tty' => 'no_tty'
      }
    }.freeze

    TRANSFORMATIONS = {
      'run' => {
        'cmd' => ->(x) { x.split(' ') }
      }
    }.freeze

    def run(runs)
      runs.each do |r|
        mapped_options = mapped_run_options(r)

        with_compose_session(mapped_options) do |session|
          begin
            session.run(mapped_options['service'], *mapped_options['cmd'], mapped_options)
          rescue Docker::Compose::Error => e
            raise RunExitCodeError, e.message
          end
        end
      end
    end

    #
    # Map run options for `Docker::Compose::Session`
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

    private def with_compose_session(run)
      session = Docker::Compose::Session.new(shell,
                                             dir: '.',
                                             file: run['docker_compose_file'])

      yield(session)
    end

    private def shell
      @shell ||= Backticks::Runner.new(buffered: %i[stdout stderr], interactive: true)
    end
  end
end
