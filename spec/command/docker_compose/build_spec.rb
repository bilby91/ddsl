# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Command::DockerCompose::Build do
  subject { described_class.new(shell) }

  let(:shell) { double(DDSL::Shell) }
  let(:spec) do
    {
      'name' => 'test-build',
      'file' => 'docker-compose.yml'
    }
  end

  describe '#build' do
    it 'calls the docker executable correctly' do
      expect(shell).to receive(:call!).with(
        %w[docker-compose --file docker-compose.yml build]
      )

      subject.run(spec)
    end

    context 'when service is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build test]
        )

        subject.run(spec.merge('service' => 'test'))
      end
    end

    context 'when build_args map are given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --memory 100M]
        )

        subject.run(spec.merge('memory' => '100M'))
      end
    end

    context 'when build_args map are given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --build-arg COMPILE=true]
        )

        subject.run(spec.merge('build_args' => { 'COMPILE' => 'true' }))
      end
    end

    context 'when parallel flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --parallel]
        )

        subject.run(spec.merge('parallel' => true))
      end
    end

    context 'when compress flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --compress]
        )

        subject.run(spec.merge('compress' => true))
      end
    end

    context 'when force_rm flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --force-rm]
        )

        subject.run(spec.merge('force_rm' => true))
      end
    end

    context 'when pull flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --pull]
        )

        subject.run(spec.merge('pull' => true))
      end
    end

    context 'when no_cache flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml build --no-cache]
        )

        subject.run(spec.merge('no_cache' => true))
      end
    end
  end
end
