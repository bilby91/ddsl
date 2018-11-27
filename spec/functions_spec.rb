# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Functions do
  describe '#map_keys_matching' do
    it 'returns the transformed hash' do
      expect(
        described_class[:map_keys_matching].call(
          { 'key' => 'value' },
          /.*/,
          ->(x) { x.upcase }
        )
      ).to eq('KEY' => 'value')
    end
  end

  describe '#optionize_keys' do
    it 'returns the transformed hash' do
      expect(
        described_class[:optionize_keys].call(
          'key' => 'value', 'long_key' => 'long value', 'e' => 'single'
        )
      ).to eq('--key' => 'value', '--long-key' => 'long value', '-e' => 'single')
    end
  end

  describe '#expand_options' do
    it 'returns the transformed hash' do
      expect(
        described_class[:expand_options].call(
          'key' => 'value', 'array' => %w[opt1 opt2], 'flag' => true
        )
      ).to eq(%w[key value array opt1 array opt2 flag])
    end
  end
end
