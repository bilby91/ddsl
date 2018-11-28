# frozen_string_literal: true

require 'spec_helper'

describe DDSL::CLI do
  include FileHelper

  subject { DDSL::CLI.new('.') }

  let(:config_file) do
    tmp_file('test.yml', <<~YML
      version: 1
      builds:
        - name: main
          type: docker
          context: .
          file: Dockerfile
          build_args:
            FOO: bar
        - name: dev
          type: docker-compose
          file: docker-compose.yml
          build_args:
            FOO: bar

      runs:
        - name: test-docker
          type: docker
          image: test/test:latest
          cmd: /echo.sh

        - name: test-docker-compose
          type: docker-compose
          service: test
          cmd: /echo.sh
    YML
  )
  end

  context 'when invoking unknown subcommand' do
    it 'raises Clamp::HelpWanted' do
      expect do
        subject.run(%w[])
      end.to raise_error(Clamp::HelpWanted)
    end
  end

  context 'when invoking build subcommand' do
    context 'when NAME of the build is not given' do
      it 'raises Clamp::UsageError' do
        expect do
          subject.run(%w[build])
        end.to raise_error(Clamp::UsageError)
      end
    end

    context 'when invalid NAME is given' do
      it 'raises Clamp::UsageError' do
        expect do
          subject.run(%W[--config #{config_file.path} build foo])
        end.to raise_error(Clamp::UsageError)
      end
    end

    context 'when valid NAME is given' do
      context 'when type of run spec is docker' do
        context 'when command is successful' do
          it 'calls DDSL::Command::Docker::Build#build with the correct arguments' do
            expect_any_instance_of(DDSL::Command::Docker::Build).to receive(:run).with(
              'name' => 'main',
              'type' => 'docker',
              'context' => '.',
              'file' => 'Dockerfile',
              'build_args' => {
                'FOO' => 'bar'
              }
            )

            subject.run(%W[--config #{config_file.path} build main])
          end
        end

        context 'when command is raises DDSL::Shell::ExitStatusError' do
          it 'handles the error and raises SystemExit' do
            expect_any_instance_of(DDSL::Command::Docker::Build).to receive(:run)
              .and_raise(DDSL::Shell::ExitStatusError)
            expect do
              subject.run(%W[--config #{config_file.path} build main])
            end.to raise_error(SystemExit)
          end
        end
      end

      context 'when type of run spec is docker-compose' do
        context 'when command is successful' do
          it 'calls DDSL::Command::DockerCompose::Build#build with the correct arguments' do
            expect_any_instance_of(DDSL::Command::DockerCompose::Build).to receive(:run).with(
              'name' => 'dev',
              'type' => 'docker-compose',
              'file' => 'docker-compose.yml',
              'build_args' => {
                'FOO' => 'bar'
              }
            )

            subject.run(%W[--config #{config_file.path} build dev])
          end
        end

        context 'when command is raises DDSL::Shell::ExitStatusError' do
          it 'handles the error and raises SystemExit' do
            expect_any_instance_of(DDSL::Command::DockerCompose::Build).to receive(:run)
              .and_raise(DDSL::Shell::ExitStatusError)

            expect do
              subject.run(%W[--config #{config_file.path} build dev])
            end.to raise_error(SystemExit)
          end
        end
      end
    end
  end

  context 'when invoking run subcommand' do
    context 'when NAME of the build is not given' do
      it 'raises Clamp::UsageError' do
        expect do
          subject.run(%w[run])
        end.to raise_error(Clamp::UsageError)
      end
    end

    context 'when invalid NAME is given' do
      it 'raises Clamp::UsageError' do
        expect do
          subject.run(%W[--config #{config_file.path} run foo])
        end.to raise_error(Clamp::UsageError)
      end
    end

    context 'when valid NAME is given' do
      context 'when type of run spec is docker' do
        context 'when command is successful' do
          it 'calls DDSL::Command::Docker::Run#run with the correct arguments' do
            expect_any_instance_of(DDSL::Command::Docker::Run).to receive(:run).with(
              'name' => 'test-docker',
              'type' => 'docker',
              'image' => 'test/test:latest',
              'cmd' => '/echo.sh'
            )

            subject.run(%W[--config #{config_file.path} run test-docker])
          end
        end

        context 'when command is raises DDSL::Shell::ExitStatusError' do
          it 'handles the error and raises SystemExit' do
            expect_any_instance_of(DDSL::Command::Docker::Run).to receive(:run)
              .and_raise(DDSL::Shell::ExitStatusError)

            expect do
              subject.run(%W[--config #{config_file.path} run test-docker])
            end.to raise_error(SystemExit)
          end
        end
      end

      context 'when type of run spec is docker-compose' do
        context 'when command is successful' do
          it 'calls DDSL::Command::DockerCompose::Run#run with the correct arguments' do
            expect_any_instance_of(DDSL::Command::DockerCompose::Run).to receive(:run).with(
              'name' => 'test-docker-compose',
              'type' => 'docker-compose',
              'service' => 'test',
              'cmd' => '/echo.sh'
            )

            subject.run(%W[--config #{config_file.path} run test-docker-compose])
          end
        end

        context 'when command is raises DDSL::Shell::ExitStatusError' do
          it 'handles the error and raises SystemExit' do
            expect_any_instance_of(DDSL::Command::DockerCompose::Run).to receive(:run)
              .and_raise(DDSL::Shell::ExitStatusError)

            expect do
              subject.run(%W[--config #{config_file.path} run test-docker-compose])
            end.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
