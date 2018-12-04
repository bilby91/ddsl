# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Command::Docker::Login do
  subject { described_class.new(shell) }

  let(:shell) { double(DDSL::Shell) }
  let(:spec) do
    {
      'username' => 'user',
      'password' => 'pass'
    }
  end

  describe '#run' do
    it 'calls the docker executable correctly' do
      expect(shell).to receive(:call!).with(
        %w[docker login --username user --password pass]
      )

      subject.run(spec)
    end
  end
end
