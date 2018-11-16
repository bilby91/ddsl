# frozen_string_literal: true

require 'json'
require 'yaml'
require_relative './schema_validator'

module DDSL
  class Parser
    class UnsupportedFileFormatError < StandardError; end

    #
    # Parse configuration file in given path
    #
    # @param [String] file_path
    #
    # @return [Hash]
    #
    def parse(file_path)
      format = File.extname(file_path)
      parsed_config = case format
                      when '.json'
                        JSON.parse(File.read(file_path))
                      when '.yml'
                        YAML.load_file(file_path)
                      else
                        raise UnsupportedFileFormatError, "format #{format} is unsupported"
      end

      DDSL::SchemaValidator.new.validate!(parsed_config)
    end
  end
end
