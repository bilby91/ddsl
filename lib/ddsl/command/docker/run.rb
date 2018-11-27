# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module Docker
      class Run < Base
        executable 'docker'
        command 'run'

        options do
          accept_keys(%w[
                        rm envs volumes ports
                      ])

          rename_keys(
            'envs' => 'env',
            'volumes' => 'volume',
            'ports' => 'publish'
          )

          optionize_keys
          expand_options
        end

        arguments do
          accept_keys(%w[image cmd])
        end
      end
    end
  end
end
