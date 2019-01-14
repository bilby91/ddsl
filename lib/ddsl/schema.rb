# frozen_string_literal: true

require 'json_schemer'

module DDSL
  class Schema
    VERSION = :draft4

    def initialize(data)
      @data = data
    end

    def validate
      schemer_validator.validate(@data).to_a
    end

    protected def schema_path
      raise NotImplementedError
    end

    private def schemer_validator
      @schemer_validator ||= JSONSchemer.schema(
        schema_path,
        format: true,
        ref_resolver: resolver
      )
    end

    private def resolver
      lambda do |uri|
        file_name = uri.path.split('/').last
        file_path = File.join(schema_dir, file_name)

        JSON.parse(File.read(file_path))
      end
    end

    private def schema_dir
      File.join(File.dirname(__FILE__), '../../schemas')
    end
  end

  class SchemaDDSL < Schema
    protected def schema_path
      Pathname.new(File.join(schema_dir, '/ddsl.schema.json'))
    end
  end
  class SchemaBuild < Schema
    protected def schema_path
      Pathname.new(File.join(schema_dir, '/build.schema.json'))
    end
  end
  class SchemaRun < Schema
    protected def schema_path
      Pathname.new(File.join(schema_dir, '/run.schema.json'))
    end
  end
end
