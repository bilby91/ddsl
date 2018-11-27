# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Command::Docker::Run do
  subject { described_class.new(shell) }

  let(:shell) { double(DDSL::Shell) }
  let(:spec) do
    {
      'name' => 'test-build',
      'image' => 'test/test:latest'
    }
  end

  describe '#run' do
    it 'calls the docker executable correctly' do
      expect(shell).to receive(:call!).with(
        %w[docker run test/test:latest]
      )

      subject.run(spec)
    end

    context 'when cmd is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker run test/test:latest /echo.sh]
        )

        subject.run(spec.merge('cmd' => '/echo.sh'))
      end
    end

    context 'when rm flag is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker run --rm test/test:latest]
        )

        subject.run(spec.merge('rm' => true))
      end
    end

    context 'when envs map is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker run --env COMPILE=true test/test:latest]
        )

        subject.run(spec.merge('envs' => { 'COMPILE' => 'true' }))
      end
    end

    context 'when volumes map is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker run --volume /var/foo:/tmp test/test:latest]
        )

        subject.run(spec.merge('volumes' => ['/var/foo:/tmp']))
      end
    end

    context 'when ports map is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker run --publish 3000:3000 test/test:latest]
        )

        subject.run(spec.merge('ports' => ['3000:3000']))
      end
    end
  end
end
