# frozen_string_literal: true

module DDSL
  SCHEMA_VERSION  = :draft4
  SCHEMA_DIR      = File.join(File.dirname(__FILE__), '../../schemas')
  SCHEMA_PATH     = Pathname.new(File.join(SCHEMA_DIR, '/ddsl.schema.json'))
  SCHEMA_RESOLVER = lambda { |uri|
    file_name = uri.path.split('/').last
    file_path = File.join(SCHEMA_DIR, file_name)

    JSON.parse(File.read(file_path))
  }
end
