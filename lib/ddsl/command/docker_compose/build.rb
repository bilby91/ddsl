# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module DockerCompose
      class Build < Base
        executable 'docker-compose'
        command 'build'

        executable_options do
          accept_keys([
                        'file'
                      ])

          optionize_keys
          expand_options
        end

        options do
          accept_keys(%w[
                        build_args memory parallel compress force_rm pull no_cache
                      ])

          rename_keys(
            'build_args' => 'build_arg'
          )

          optionize_keys
          expand_options
        end

        arguments do
          accept_keys(['service'])
        end
      end
    end
  end
end
