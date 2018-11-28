# frozen_string_literal: true

module DDSL
  class VariableInjector
    REGEX = /\$\w+/.freeze

    attr_reader :var_map

    def initialize(var_map)
      @var_map = var_map
    end

    def inject(data)
      traverse_hash(data)
    end

    private def traverse_hash(hash)
      hash.map { |key, value| [key, process_value(value)] }.to_h
    end

    private def traverse_array(array)
      array.map { |value| process_value(value) }
    end

    private def process_value(value)
      case value
      when Array
        traverse_array(value)
      when Hash
        traverse_hash(value)
      when String
        process_content(value)
      else
        value
      end
    end

    private def process_content(content)
      content.scan(REGEX).inject(content) do |replaced, match|
        replace_content(replaced, match)
      end
    end

    private def replace_content(content, match)
      key = var_map_key(match)

      var_map.key?(key) ? content.gsub(match, var_map[key]) : content
    end

    private def var_map_key(match)
      match.delete('$')
    end
  end
end
