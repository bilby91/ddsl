# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module DockerCompose
      class Run < Base
        executable 'docker-compose'
        command 'run'

        executable_options do
          accept_keys([
                        'file'
                      ])

          optionize_keys
          expand_options
        end

        options do
          accept_keys(%w[
                        rm envs volumes ports service_ports user workdir no_deps detach
                      ])

          rename_keys(
            'envs' => 'e',
            'volumes' => 'volume',
            'ports' => 'publish'
          )

          optionize_keys
          expand_options
        end

        arguments do
          accept_keys(%w[service cmd])
        end
      end
    end
  end
end
