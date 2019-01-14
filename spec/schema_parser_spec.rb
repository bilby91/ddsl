# frozen_string_literal: true

require 'spec_helper'

describe DDSL::SchemaParser do
  subject { DDSL::SchemaParser.new }

  describe '#parse!' do
    context 'when version is missing' do
      it 'raises a validation error' do
        expect do
          subject.parse!({})
        end.to raise_error(DDSL::SchemaParser::InvalidError)
      end
    end

    context 'when version is not supported' do
      it 'raises a validation error' do
        expect do
          subject.parse!('version' => -1)
        end.to raise_error(DDSL::SchemaParser::InvalidError)
      end
    end

    context 'when version is supported' do
      it 'doesn\'t raise an error' do
        expect do
          subject.parse!('version' => 1)
        end.not_to raise_error
      end
    end

    context 'when adding random properties' do
      it 'raises a validation error' do
        expect do
          subject.parse!('version' => 1, 'random' => 'value')
        end.to raise_error(DDSL::SchemaParser::InvalidError)
      end
    end

    context 'when a registry is given' do
      context 'when required properties are missing' do
        it 'raises a validation error' do
          expect do
            subject.parse!(
              'version' => 1,
              'registries' => [{}]
            )
          end.to raise_error(DDSL::SchemaParser::InvalidError)
        end

        context 'when required properties are present' do
          let(:registry) do
            {
              'url' => 'docker.test.com',
              'username' => 'user',
              'password' => 'pass'
            }
          end

          it 'doesn\'t raise an error' do
            expect do
              subject.parse!(
                'version' => 1,
                'registries' => [registry]
              )
            end.not_to raise_error
          end
        end
      end
    end

    context 'when a build is given' do
      context 'when required properties are missing' do
        it 'raises a validation error' do
          expect do
            subject.parse!(
              'version' => 1,
              'builds' => [{}]
            )
          end.to raise_error(DDSL::SchemaParser::InvalidError)
        end

        context 'when required properties are present' do
          let(:build) do
            {
              'name' => 'test',
              'type' => 'docker',
              'context' => '.',
              'file' => 'Dockerfile'
            }
          end

          it 'doesn\'t raise an error' do
            expect do
              subject.parse!(
                'version' => 1,
                'builds' => [build]
              )
            end.not_to raise_error
          end

          context 'when template is used in a build' do
            before do
              build.merge!('templates' => ['test-template'])
            end

            context 'when template adds incompatible specs to the build' do
              let(:templates) do
                {
                  'name' => 'test-template',
                  'build_args' => 1
                }
              end

              it 'raises a validation error' do
                expect do
                  subject.parse!(
                    'version' => 1,
                    'templates' => [templates],
                    'builds' => [build]
                  )
                end.to raise_error(DDSL::SchemaParser::InvalidError)
              end
            end

            context 'when template adds incompatible specs to the build' do
              let(:templates) do
                {
                  'name' => 'test-template',
                  'push' => true
                }
              end

              it 'doesn\'t raise an error' do
                expect do
                  subject.parse!(
                    'version' => 1,
                    'templates' => [templates],
                    'builds' => [build]
                  )
                end.not_to raise_error
              end
            end
          end
        end
      end
    end

    context 'when a run is given' do
      context 'when required properties are missing' do
        it 'raises a validation error' do
          expect do
            subject.parse!(
              'version' => 1,
              'runs' => [{}]
            )
          end.to raise_error(DDSL::SchemaParser::InvalidError)
        end

        context 'when type is docker' do
          context 'when required properties are missing' do
            it 'raises a validation error' do
              expect do
                subject.parse!(
                  'version' => 1,
                  'runs' => [{}]
                )
              end.to raise_error(DDSL::SchemaParser::InvalidError)
            end
          end

          context 'when required properties are present' do
            context 'when type is docker' do
              let(:run) do
                {
                  'name' => 'test',
                  'type' => 'docker',
                  'image' => 'docker/docker'
                }
              end

              it 'doesn\'t raise an error' do
                expect do
                  subject.parse!(
                    'version' => 1,
                    'runs' => [run]
                  )
                end.not_to raise_error
              end
            end

            context 'when type is docker-compose' do
              let(:run) do
                {
                  'name' => 'test',
                  'type' => 'docker-compose',
                  'service' => 'test_service'
                }
              end
              it 'doesn\'t raise an error' do
                expect do
                  subject.parse!(
                    'version' => 1,
                    'runs' => [run]
                  )
                end.not_to raise_error
              end
            end

            context 'when template is used in the run' do
              let(:run) do
                {
                  'name' => 'test',
                  'templates' => ['test-template'],
                  'type' => 'docker',
                  'image' => 'docker/docker'
                }
              end

              context 'when template adds incompatible specs to the run' do
                let(:templates) do
                  {
                    'name' => 'test-template',
                    'cmd' => 1
                  }
                end

                it 'raises a validation error' do
                  expect do
                    subject.parse!(
                      'version' => 1,
                      'templates' => [templates],
                      'runs' => [run]
                    )
                  end.to raise_error(DDSL::SchemaParser::InvalidError)
                end
              end

              context 'when template adds incompatible specs to the run' do
                let(:templates) do
                  {
                    'name' => 'test-template',
                    'cmd' => 'echo "test"'
                  }
                end

                it 'doesn\'t raise an error' do
                  expect do
                    subject.parse!(
                      'version' => 1,
                      'templates' => [templates],
                      'runs' => [run]
                    )
                  end.not_to raise_error
                end
              end
            end
          end
        end
      end
    end
  end
end
