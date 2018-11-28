# frozen_string_literal: true

require 'spec_helper'

describe DDSL::VariableInjector do
  let(:var_map) do
    {
      'VAR1' => 'value1'
    }
  end

  subject { DDSL::VariableInjector.new(var_map) }

  describe '#inject' do
    context 'when data doesn\'t contain variable interpolation' do
      it 'returns the data unmodified' do
        expect(
          subject.inject('key1' => '1', 'key2' => 2)
        ).to eq('key1' => '1', 'key2' => 2)
      end
    end

    context 'when data contains variable interpolation' do
      context 'when interpolation is for an undefined variable' do
        it 'returns the data unmodified' do
          expect(
            subject.inject('key' => 'va $VAR2 lue')
          ).to eq('key' => 'va $VAR2 lue')
        end
      end

      context 'when interpolation is in a String' do
        it 'returns the data with the variable replaced' do
          expect(
            subject.inject('key' => 'va $VAR1 lue')
          ).to eq('key' => 'va value1 lue')
        end
      end

      context 'when interpolation is in an Array' do
        it 'returns the data with the variable replaced' do
          expect(
            subject.inject('key' => ['va $VAR1 lue'])
          ).to eq('key' => ['va value1 lue'])
        end
      end

      context 'when interpolation is in a Hash' do
        it 'returns the data with the variable replaced' do
          expect(
            subject.inject('key' => { 'nested' => 'va $VAR1 lue' })
          ).to eq('key' => { 'nested' => 'va value1 lue' })
        end
      end

      context 'when interpolation is in a Hash with an Array' do
        it 'returns the data with the variable replaced' do
          expect(
            subject.inject('key' => { 'nested' => ['va $VAR1 lue'] })
          ).to eq('key' => { 'nested' => ['va value1 lue'] })
        end
      end
    end
  end
end
