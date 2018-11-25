# frozen_string_literal: true

require 'spec_helper'

describe DDSL::DockerComposeRunner do
  include FileHelper

  subject { DDSL::DockerComposeRunner.new }

  let(:docker_compose_file) do
    tmp_file('docker-compose.yml', <<~YML
      version: '3'
      services:
        test:
          image: alpine
          command: echo Worked!
    YML
  )
  end

  describe '#run' do
    let(:run_spec) do
      {
        'name' => 'test-run',
        'service' => 'test',
        'docker_compose_file' => docker_compose_file.path,
        'cmd' => 'echo Test'
      }
    end

    context 'when container exits with status 0' do
      it 'doesn\'t raise an error when running the container exits with status 0' do
        expect do
          subject.run([run_spec])
        end.not_to raise_error
      end
    end

    context 'when container exits with status 0' do
      it 'raise an error when running the container exits with status different than 0' do
        expect do
          subject.run([run_spec.merge('cmd' => 'eco Test')])
        end.to raise_error(DDSL::DockerComposeRunner::RunExitCodeError)
      end
    end
  end
end
