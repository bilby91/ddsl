# frozen_string_literal: true

module DDSL
  module Mappable
    #
    # Map the given hash by applying the given transformation specs
    #
    # @param [Hash] transformable
    # @param [Hash] specs
    #
    # @return [Hash] new hash with transformation specs applied
    #
    def transform_options(transformable, specs)
      specs.inject(transformable) do |options, (matcher, func)|
        case matcher
        when String
          apply_to_key(options, matcher, func)
        when Regexp
          apply_to_matching_keys(options, matcher, func)
        end
      end
    end

    # Map the given hash keys using the given translation specs
    #
    # @param [Hash] translateable
    # @param [Hash] specs
    #
    # @return [Hash] new hash with translation specs applied
    #
    def translate_options(translateable, specs)
      specs.inject(translateable) do |options, (source, target)|
        if options[source].nil?
          options
        else
          value = options.delete(source)
          options.merge(target => value)
        end
      end
    end

    #
    # Remove any unknown keys using the given whitelist spec
    #
    # @param [Hash] whitelistable
    # @param [Array] specs
    #
    # @return [Hash] new hash with unknown keys removed
    #
    def whitelist_options(whitelistable, specs)
      whitelistable.dup.keep_if { |k, _v| specs.include? k }
    end

    private def apply_to_key(hash, key, func)
      if hash[key].nil?
        hash
      else
        hash.merge(key => func.call(hash[key]))
      end
    end

    private def apply_to_matching_keys(hash, regex, func)
      hash.map do |key, value|
        if regex&.match?(key)
          [key, func.call(value)]
        else
          [key, value]
        end
      end.to_h
    end
  end
end
