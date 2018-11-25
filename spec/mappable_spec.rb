# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Mappable do
  # We include the module to test the methods
  include DDSL::Mappable

  describe '#transform_options' do
    context 'when transformable target is empty' do
      it 'returns an empty hash' do
        expect(
          transform_options({}, 'foo' => ->(x) { x.split(' ') })
        ).to eq({})
      end
    end

    context 'when transformable contains keys out of the spec' do
      it 'returns the same hash' do
        expect(
          transform_options({ 'missing' => 'key' }, 'foo' => ->(x) { x.split(' ') })
        ).to eq('missing' => 'key')
      end
    end

    context 'when transformable contains keys in the spec' do
      it 'returns the transformed hash' do
        expect(
          transform_options({ 'foo' => 'v a l u e' }, 'foo' => ->(x) { x.split(' ') })
        ).to eq('foo' => %w[v a l u e])
      end
    end
  end

  describe '#translate_options' do
    context 'when translatable target is empty' do
      it 'returns an empty hash' do
        expect(
          translate_options({}, 'foo' => 'bar')
        ).to eq({})
      end
    end

    context 'when translatable contains keys out of the spec' do
      it 'returns the same hash' do
        expect(
          translate_options({ 'missing' => 'key' }, 'foo' => 'bar')
        ).to eq('missing' => 'key')
      end
    end

    context 'when translatable contains keys in the spec' do
      it 'returns the translated hash' do
        expect(
          translate_options({ 'foo' => 'value' }, 'foo' => 'bar')
        ).to eq('bar' => 'value')
      end
    end
  end

  describe '#twhitelist_options' do
    context 'when whitelistable target is empty' do
      it 'returns an empty hash' do
        expect(
          whitelist_options({}, ['foo'])
        ).to eq({})
      end
    end

    context 'when whitelistable contains keys out of the spec' do
      it 'returns the whitelisted hash' do
        expect(
          whitelist_options({ 'bar' => 'value' }, ['foo'])
        ).to eq({})
      end
    end
    context 'when whitelistable contains keys in the spec' do
      it 'returns the whitelisted hash' do
        expect(
          whitelist_options({ 'foo' => 'value' }, ['foo'])
        ).to eq('foo' => 'value')
      end
    end
  end
end
