# frozen_string_literal: true

require 'spec_helper'

describe DDSL::CLI do
  include FileHelper

  subject { DDSL::CLI.new('.') }

  let(:config_file) do
    tmp_file('test.yml', <<~EOF
      version: 1
      builds:
        - name: main
          context: .
          dockerfile: Dockerfile
          build_args:
            FOO: bar

      runs:
        - name: test
          type: docker
          image: test/test:latest
          cmd: /echo.sh
    EOF
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
      it 'calls DockerRunner#build with the correct arguments' do
        expect_any_instance_of(DDSL::DockerRunner).to receive(:build).with(
          [
            {
              'name' => 'main',
              'context' => '.',
              'dockerfile' => 'Dockerfile',
              'build_args' => {
                'FOO' => 'bar'
              }
            }
          ]
        )

        subject.run(%W[--config #{config_file.path} build main])
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
      it 'calls DockerRunner#run with the correct arguments' do
        expect_any_instance_of(DDSL::DockerRunner).to receive(:run).with(
          [
            {
              'name' => 'test',
              'type' => 'docker',
              'image' => 'test/test:latest',
              'cmd' => '/echo.sh'
            }
          ]
        )

        subject.run(%W[--config #{config_file.path} run test])
      end
    end
  end
end
