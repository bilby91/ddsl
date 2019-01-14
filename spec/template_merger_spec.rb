# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a templatable key' do |key|
  context "when templates add missing keys in #{key}" do
    before do
      spec.merge!('templates' => [
                    {
                      'name' => 'test-template',
                      't1' => 't1'
                    }
                  ])
    end

    it "updates the #{key} with the new key" do
      expect(subject.apply[key][0]).to eq(
        'b1' => 'b1',
        'b2' => 'b2',
        't1' => 't1'
      )
    end
  end

  context "when templates adds an already present key in the #{key}" do
    before do
      spec.merge!('templates' => [
                    {
                      'name' => 'test-template',
                      'b1' => 't1'
                    }
                  ])
    end

    it "favors the #{key} key" do
      expect(subject.apply[key][0]).to eq(
        'b1' => 'b1',
        'b2' => 'b2'
      )
    end
  end

  context "when any value in #{key} refereces a template that doesn't exist in the top `templates` key" do
    before do
      spec.merge!('templates' => [
                    {
                      'name' => 'wrong-template',
                      'b1' => ['t1']
                    }
                  ])
    end

    it 'raises DDSL::TemplateMerger::MissingTemplateError' do
      expect do
        subject.apply
      end.to raise_error(DDSL::TemplateMerger::MissingTemplateError)
    end
  end

  context "when templates adds an already present key in the #{key} with a different data type" do
    before do
      spec.merge!('templates' => [
                    {
                      'name' => 'test-template',
                      'b1' => ['t1']
                    }
                  ])
    end

    it 'raises DDSL::TemplateMerger::ValueTypeMismatchError' do
      expect do
        subject.apply
      end.to raise_error(DDSL::TemplateMerger::ValueTypeMismatchError)
    end
  end

  context "when templates extends a present key that contains an Array in the #{key}" do
    before do
      spec['templates'] = [
        {
          'name' => 'test-template',
          'array' => ['t1']
        }
      ]

      spec[key][0].merge!('array' => ['b1'])
    end

    it "favors the #{key} key" do
      expect(subject.apply[key][0]).to eq(
        'b1' => 'b1',
        'b2' => 'b2',
        'array' => %w[b1 t1]
      )
    end
  end

  context "when templates extends a present key that contains an Hash in the #{key}" do
    before do
      spec['templates'] = [
        {
          'name' => 'test-template',
          'hash' => { 't1' => 't1' }
        }
      ]

      spec[key][0].merge!('hash' => { 'b1' => 'b1' })
    end

    it "favors the #{key} key" do
      expect(subject.apply[key][0]).to eq(
        'b1' => 'b1',
        'b2' => 'b2',
        'hash' => { 'b1' => 'b1', 't1' => 't1' }
      )
    end

    context 'when template overrides a key in the Hash value' do
      before do
        spec['templates'] = [
          {
            'name' => 'test-template',
            'hash' => { 't1' => 't1' }
          }
        ]

        spec[key][0].merge!('hash' => { 't1' => 'b1' })
      end

      it "favors the #{key} key" do
        expect(subject.apply[key][0]).to eq(
          'b1' => 'b1',
          'b2' => 'b2',
          'hash' => { 't1' => 'b1' }
        )
      end
    end
  end
end

describe DDSL::TemplateMerger do
  let(:spec) do
    {
      'version' => 1,
      'builds' => [
        {
          'b1' => 'b1',
          'b2' => 'b2'
        }
      ],
      'runs' => [
        {
          'b1' => 'b1',
          'b2' => 'b2'
        }
      ]
    }
  end

  subject { DDSL::TemplateMerger.new(spec) }

  describe '#apply' do
    context 'when spec doesn\'t have templates' do
      it 'returns the data unchanged' do
        expect(subject.apply).to eq(spec)
      end
    end

    context 'when spec doesn\'t have builds' do
      before do
        spec.delete('builds')
      end

      it 'returns the data unchanged' do
        expect(subject.apply).to eq(spec)
      end
    end

    context 'when spec doesn\'t have runs' do
      before do
        spec.delete('runs')
      end

      it 'returns the data unchanged' do
        expect(subject.apply).to eq(spec)
      end
    end

    context 'when spec has templates' do
      context 'when template used in builds' do
        before do
          spec['builds'][0].merge!('templates' => ['test-template'])
        end

        it_behaves_like 'a templatable key', 'builds'
      end

      context 'when template used in runs' do
        before do
          spec['runs'][0].merge!('templates' => ['test-template'])
        end

        it_behaves_like 'a templatable key', 'runs'
      end
    end
  end
end
