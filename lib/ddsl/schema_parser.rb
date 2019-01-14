# frozen_string_literal: true

require 'json_schemer'
require_relative './schema'
require_relative './template_merger'

module DDSL
  class SchemaParser
    class InvalidError < StandardError; end

    SCHEMA_MAP = {
      'builds' => SchemaBuild,
      'runs' => SchemaRun
    }.freeze

    #
    # Parse given potentially compatible data schema. Parser will merge template values if used.
    #
    # @raise [InvalidError] if data is not compliant with the schema
    #
    # @param [Hash] data
    #
    # @return [Hash] data
    #
    def parse!(data)
      errors = SchemaDDSL.new(data).validate

      # Validate initial schema without potential templates applied
      raise InvalidError, 'Invalid schema' if errors&.count&.positive?

      # Apply potentially defined templates to the data
      applied_data = DDSL::TemplateMerger.new(data).apply

      # Re evaluate schema in case template corrupted the data
      %w[builds runs].each { |x| validate_schema_key!(applied_data, x) }

      applied_data
    end

    private def validate_schema_key!(data, key)
      return unless data.key?(key)

      data[key].each do |build|
        errors = SCHEMA_MAP[key].new(build).validate

        raise InvalidError, 'Invalid schema' if errors&.count&.positive?
      end
    end
  end
end
