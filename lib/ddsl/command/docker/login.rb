# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module Docker
      class Login < Base
        executable 'docker'
        command 'login'

        options do
          accept_keys(%w[username password])

          optionize_keys
          expand_options
        end

        arguments do
          accept_keys(%w[url])
        end
      end
    end
  end
end
