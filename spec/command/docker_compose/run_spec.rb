# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Command::DockerCompose::Run do
  subject { described_class.new(shell) }

  let(:shell) { double(DDSL::Shell) }
  let(:spec) do
    {
      'name' => 'test-build',
      'service' => 'test',
      'file' => 'docker-compose.yml'
    }
  end

  describe '#run' do
    it 'calls the docker-compose executable correctly' do
      expect(shell).to receive(:call!).with(
        %w[docker-compose --file docker-compose.yml run test]
      )

      subject.run(spec)
    end

    context 'when cmd is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run test /echo.sh]
        )

        subject.run(spec.merge('cmd' => '/echo.sh'))
      end
    end

    context 'when rm flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --rm test]
        )

        subject.run(spec.merge('rm' => true))
      end
    end

    context 'when service_ports flag is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --service-ports test]
        )

        subject.run(spec.merge('service_ports' => true))
      end
    end

    context 'when envs map is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run -e COMPILE=true test]
        )

        subject.run(spec.merge('envs' => { 'COMPILE' => 'true' }))
      end
    end

    context 'when volumes map is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --volume /var/foo:/tmp test]
        )

        subject.run(spec.merge('volumes' => ['/var/foo:/tmp']))
      end
    end

    context 'when ports map is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --publish 3000:3000 test]
        )

        subject.run(spec.merge('ports' => ['3000:3000']))
      end
    end

    context 'when user is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --user root test]
        )

        subject.run(spec.merge('user' => 'root'))
      end
    end

    context 'when workdir is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --workdir /var/foo test]
        )

        subject.run(spec.merge('workdir' => '/var/foo'))
      end
    end

    context 'when no_deps is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --no-deps test]
        )

        subject.run(spec.merge('no_deps' => true))
      end
    end

    context 'when detach is given' do
      it 'calls the docker-compose executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker-compose --file docker-compose.yml run --detach test]
        )

        subject.run(spec.merge('detach' => true))
      end
    end
  end
end
