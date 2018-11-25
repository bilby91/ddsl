# frozen_string_literal: true

require 'spec_helper'

describe DDSL::DockerRunner do
  include FileHelper

  let(:io) { new_writable_tmp_file('runner.out') }

  subject { DDSL::DockerRunner.new(io) }

  after { io.close }

  let(:dockerfile) do
    tmp_file('Dockerfile', <<~DOCKER
      FROM alpine
      ARG FOO
      ARG BAR
      RUN echo ${FOO}
      RUN echo ${BAR}
      CMD echo "Worked!"
    DOCKER
  )
  end

  let(:build_spec) do
    {
      'name' => 'test-build',
      'context' => File.dirname(dockerfile.path),
      'dockerfile' => File.basename(dockerfile.path),
      'tags' => ['test/test:latest'],
      'build_args' => {
        'FOO' => 'foo1',
        'BAR' => 'bar1'
      }
    }
  end

  describe '#build' do
    it 'doesn\'t raise an error when building the image' do
      expect do
        subject.build([build_spec])
      end.not_to raise_error
    end

    it 'tags the image' do
      expect(subject.build([build_spec])[0]).to have_tag('test/test:latest')
    end
  end

  describe '#run' do
    let(:image_tag) { subject.build([build_spec])[0].info['id'] }

    let(:run_spec) do
      {
        'name' => 'test-run',
        'image' => image_tag
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
          subject.run([run_spec.merge('cmd' => 'eco "Test"')])
        end.to raise_error(DDSL::DockerRunner::RunExitCodeError)
      end
    end
  end
end
