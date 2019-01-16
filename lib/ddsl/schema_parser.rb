# frozen_string_literal: true

require 'json_schemer'
# require 'pp'
require_relative './schema'
require_relative './template_merger'

module DDSL
  class SchemaParser
    class InvalidError < StandardError; end

    APPLICATIVES = [DDSL::TemplateMerger].freeze
    
    # SCHEMA_MAP = {
    #   'builds' => SchemaBuild,
    #   'runs' => SchemaRun
    # }.freeze

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
      transformed_data = APPLICATIVES.inject(data) do |schema_instance, applicative|
        validate_data!(schema_instance)
        
        applicative.new(schema_instance).apply
      end

      # We need to validate one more time since the last applicative applied is not validated
      validate_data!(transformed_data)

      transformed_data
    end

    private def validate_data!(data)
      errors = SchemaDDSL.new(data).validate

      p "first"
      if errors.count > 0
        # errors = SchemaBuild.new(data['builds'][0]).validate

        errors.each do |e|
          next if e['data_pointer'] =~ /\/builds\/\d\/type/

          # p data
          # p e['data_pointer'].split('/').delete_if(&:empty?)
          foo = e['data_pointer'].split('/').delete_if(&:empty?).inject(data) do |x, path|
            # p "fooo"
            p x
            case x
            when Array
              x[path.to_i]
            else
              x[path]
            end
            # x
            # x[path]
          end

          p foo
          "/builds/3/tags/0"
          "boolean"
          "maximium"
          
          # puts "Data: #{e['data']}"
          # puts "Data Pointer: #{e['data_pointer']}"
          # puts "Type: #{e['type']}"
          # puts "Schema: #{e['schema']}"
          # puts "Root Schema: #{e}"
          # puts
        end
      end
      
      raise InvalidError, 'Invalid schema' if errors&.count&.positive?
    end
  end
end
