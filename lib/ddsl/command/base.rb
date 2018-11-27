# frozen_string_literal: true

require_relative './dsl'

module DDSL
  module Command
    class Base
      include DSL

      def initialize(shell = DDSL::Shell.new)
        @shell = shell
      end

      def run(spec)
        argv = [
          executable,
          executable_options.call(spec),
          command,
          options.call(spec),
          arguments.call(spec).values
        ].flatten

        @shell.call!(argv)
      end
    end
  end
end
