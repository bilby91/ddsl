# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module Docker
      class Pull < Base
        executable 'docker'
        command 'pull'

        arguments do
          accept_keys(['image'])
        end
      end
    end
  end
end
