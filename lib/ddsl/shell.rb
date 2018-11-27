# frozen_string_literal: true

module DDSL
  class Shell
    class ExitStatusError < StandardError; end

    #
    # Run given list of arguments in a shell.
    #
    # Note: $stdin, $stout and $stderr will be forwarded
    #
    # @raise [ExitStatusError] if program fails
    #
    # @param [Array<String>] argv
    #
    # @return [void]
    #
    def call!(argv)
      raise ExitStatusError unless invoke(argv)
    end

    #
    # Invoke given argument list in a subshell
    #
    # @param [Array<String>] argv
    #
    # @return [Bool] true if exit status of the program is 0, no otherwise
    #
    def invoke(argv)
      system(
        argv.join(' ')
      )
    end
  end
end
