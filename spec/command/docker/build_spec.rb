# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Command::Docker::Build do
  subject { described_class.new(shell) }

  let(:shell) { double(DDSL::Shell) }
  let(:spec) do
    {
      'name' => 'test-build',
      'context' => '.',
      'file' => 'Dockerfile'
    }
  end

  describe '#build' do
    it 'calls the docker executable correctly' do
      expect(shell).to receive(:call!).with(
        %w[docker build --file Dockerfile .]
      )

      subject.run(spec)
    end

    context 'when tags list is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker build --file Dockerfile --tag test/test:latest .]
        )

        subject.run(spec.merge('tags' => ['test/test:latest']))
      end

      context 'when push flag is true' do
        it 'calls the docker executable correctly to push the image' do
          expect(shell).to receive(:call!).with(
            %w[docker build --file Dockerfile --tag test/test:latest .]
          )
          expect(shell).to receive(:call!).with(
            %w[docker push test/test:latest]
          )

          subject.run(spec.merge('push' => true, 'tags' => ['test/test:latest']))
        end
      end
    end

    context 'when build_args map are given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker build --file Dockerfile --build-arg COMPILE=true .]
        )

        subject.run(spec.merge('build_args' => { 'COMPILE' => 'true' }))
      end
    end

    context 'when labels are given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker build --file Dockerfile --label env=test .]
        )

        subject.run(spec.merge('labels' => { 'env' => 'test' }))
      end
    end

    context 'when cache_from map is given' do
      it 'calls the docker executable correctly' do
        expect(shell).to receive(:call!).with(
          %w[docker build --file Dockerfile --cache-from test:/test:latest .]
        )

        subject.run(spec.merge('cache_from' => ['test:/test:latest']))
      end
    end
  end
end
