# frozen_string_literal: true

require 'json-schema'
require_relative './schema'

module DDSL
  class SchemaValidator
    class InvalidError < StandardError; end

    #
    # Validate given data against DDSL schema. Will add any defaults if nil values are found
    #
    # @raise [InvalidError] if data is not compliant with the schema,
    #
    # @param [Hash] data
    #
    # @return [Hash] data with defaults if appropiate
    #
    def validate!(data)
      errors = JSON::Validator.fully_validate(DDSL::SCHEMA, data,
                                              version: DDSL::SCHEMA_VERSION,
                                              insert_defaults: true)

      raise InvalidError, errors.join('\n') if errors.count.positive?

      data
    end
  end
end
