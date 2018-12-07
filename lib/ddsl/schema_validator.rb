# frozen_string_literal: true

require 'json_schemer'
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
      errors = json_schema_validator.validate(data).to_a
      raise InvalidError, 'Invalid schema' if errors&.count&.positive?

      data
    end

    private def json_schema_validator
      @json_schema_validator ||= JSONSchemer.schema(
        DDSL::SCHEMA_PATH,
        format: true,
        ref_resolver: DDSL::SCHEMA_RESOLVER
      )
    end
  end
end
