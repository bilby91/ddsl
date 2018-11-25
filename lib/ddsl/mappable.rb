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
      specs.inject(transformable) do |options, (key, func)|
        if options[key].nil?
          options
        else
          options.merge(key => func.call(options[key]))
        end
      end
    end

    #
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
      whitelistable.keep_if { |k, _v| specs.include? k }
    end
  end
end
