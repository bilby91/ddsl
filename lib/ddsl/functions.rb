# frozen_string_literal: true

require 'transproc/all'

module DDSL
  module Functions
    extend Transproc::Registry

    import Transproc::HashTransformations
    import Transproc::ArrayTransformations

    def self.idempotency(value)
      value
    end

    def self.map_keys_matching(hash, regex, func)
      hash.map do |key, value|
        if regex&.match(key)
          [func.call(key), value]
        else
          [key, value]
        end
      end.to_h
    end

    def self.optionize_keys(hash)
      [
        [:map_keys_matching, /\w+_\w+/, ->(x) { x.tr('_', '-') }],
        [:map_keys_matching, /^.{2,}$/, ->(x) { '--' + x }],
        [:map_keys_matching, /^.{1}$/, ->(x) { '-' + x }]
      ].inject(Functions[:idempotency]) do |pipe, args|
        pipe >> Functions[*args]
      end.call(hash)
    end

    def self.expand_options(hash)
      hash.map do |key, value|
        case value
        when String
          [key, value]
        when TrueClass, FalseClass
          key
        when Array
          value.map { |v| [key, v] }
        when Hash
          value.map { |sub_key, v| [key, "#{sub_key}=#{v}"] }
        end
      end.flatten
    end
  end
end
