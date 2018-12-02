# frozen_string_literal: true

require_relative './dsl'

module DDSL
  module Command
    class Base
      include DSL

      attr_reader :shell

      def initialize(shell = DDSL::Shell.new)
        @shell = shell
      end

      def run(spec)
        exec_before_block(spec)

        argv = [
          executable,
          executable_options.call(spec),
          command,
          options.call(spec),
          arguments.call(spec).values
        ].flatten

        @shell.call!(argv)

        exec_after_block(spec)
      end

      def exec_before_block(spec)
        instance_exec(spec, &before_block) unless before_block.nil?
      end

      def exec_after_block(spec)
        instance_exec(spec, &after_block) unless after_block.nil?
      end
    end
  end
end
