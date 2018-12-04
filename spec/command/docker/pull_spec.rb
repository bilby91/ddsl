# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Command::Docker::Pull do
  subject { described_class.new(shell) }

  let(:shell) { double(DDSL::Shell) }
  let(:spec) do
    {
      'image' => 'test/test:latest'
    }
  end

  describe '#run' do
    it 'calls the docker executable correctly' do
      expect(shell).to receive(:call!).with(
        %w[docker pull test/test:latest]
      )

      subject.run(spec)
    end
  end
end
