# frozen_string_literal: true

module DDSL
  class TemplateMerger
    class MissingTemplateError < StandardError; end
    class ValueTypeMismatchError < StandardError; end

    # Set of keys that can't be extracted from a template
    SKIPPABLE_TEMPLATE_KEYS = %w[name].freeze

    # Set of keys that can't be merged in a templatable hash
    SKIPPABLE_MERGE_KEYS = %w[templates].freeze

    # Keys that can use the templates feature
    TEMPLETABLE_KEYS = %w[builds runs].freeze

    attr_reader :data

    def initialize(data)
      @data = data.dup
    end

    #
    # Apply `build` and `run` templates to data
    #
    # @note `templates` key will be removed from objects after they are applied
    #
    # @return [Hash]
    #
    def apply
      TEMPLETABLE_KEYS.each do |key|
        data[key] = data[key].map { |b| apply_templates(b) } if data.key?(key)
      end

      data
    end

    #
    # Merge values of all inherited templates for the given templetable object
    #
    # @param [Hash] templatable
    #
    # @return [Hash]
    #
    private def apply_templates(templatable)
      templates = templatable['templates'] || []

      templates.inject(templatable) do |applied, template_name|
        template = find_template!(template_name)

        mergable_key_space(template, applied).map do |key|
          [key, extend_value!(template[key], applied[key])]
        end.to_h
      end
    end

    #
    # Extend the given spec_value in case it's type is Array or Hash, return the spec_value otherwise
    #
    # @raise [ValueTypeMismatchError] if template_value and spec_value are not nil and have different types
    #
    # @param [Array|Hash|Object] template_value
    # @param [Array|Hash|Object] spec_value
    #
    # @return [Array|Hash|Object]
    #
    private def extend_value!(template_value, spec_value)
      # Short circuit if either template_value or spec_value are nil
      return spec_value || template_value if template_value.nil? || spec_value.nil?

      # Check for data type mismatches
      unless template_value.is_a?(spec_value.class)
        raise ValueTypeMismatchError, "#{template_value} has a different type than #{spec_value}"
      end

      case template_value
      when Array
        # Template values are concatenated at the end
        spec_value.concat(template_value)
      when Hash
        # We merge the spec_value in order to favor "old" values vs template values
        # in case of a collision
        template_value.merge(spec_value)
      else
        # We favor spec values vs templates values on collisions again
        spec_value
      end
    end

    #
    # Build array of uniq keys that compose the templetable hash.
    #
    # @param [Hash] template
    # @param [Hash] templatable
    #
    # @return [Array<String>]
    #
    private def mergable_key_space(template, templatable)
      Set.new(template.keys.concat(templatable.keys))
         .to_a
         .delete_if { |x| SKIPPABLE_MERGE_KEYS.include?(x) }
    end

    #
    # Lookup for template by given name in the data object.
    #
    # @raise [MissingTemplateError] if template can't be found
    #
    # @param [String] name
    #
    # @return [Hash]
    #
    private def find_template!(name)
      template = data['templates'].find { |t| t['name'] == name }

      raise MissingTemplateError, "Missing template #{name}" if template.nil?

      template.dup.delete_if { |x| SKIPPABLE_TEMPLATE_KEYS.include?(x) }
    end
  end
end
