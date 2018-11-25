# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Parser do
  include FileHelper

  subject { DDSL::Parser.new }

  describe '#parse' do
    context 'when file is unsupported' do
      it 'raises an error' do
        expect do
          subject.parse('test.unsupported')
        end.to raise_error(DDSL::Parser::UnsupportedFileFormatError)
      end
    end

    context 'when file is json' do
      let(:file) do
        tmp_file('test.json', <<~JSON
          {
            "version": 1
          }
        JSON
      )
      end

      it 'raises an error' do
        expect(subject.parse(file.path)).to include('version' => 1)
      end
    end

    context 'when file is yml' do
      let(:file) do
        tmp_file('test.yml', <<~YML
          version: 1
        YML
      )
      end

      it 'raises an error' do
        expect(subject.parse(file.path)).to include('version' => 1)
      end
    end
  end
end
