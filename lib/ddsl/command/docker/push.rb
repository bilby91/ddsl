# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module Docker
      class Push < Base
        executable 'docker'
        command 'push'

        arguments do
          accept_keys(['image'])
        end
      end
    end
  end
end
