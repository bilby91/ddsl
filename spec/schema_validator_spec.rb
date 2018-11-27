# frozen_string_literal: true

require 'spec_helper'

describe DDSL::SchemaValidator do
  subject { DDSL::SchemaValidator.new }

  describe '#validate!' do
    context 'when version is missing' do
      it 'raises a validation error' do
        expect do
          subject.validate!({})
        end.to raise_error(DDSL::SchemaValidator::InvalidError)
      end
    end

    context 'when version is not supported' do
      it 'raises a validation error' do
        expect do
          subject.validate!(version: -1)
        end.to raise_error(DDSL::SchemaValidator::InvalidError)
      end
    end

    context 'when version is supported' do
      it 'doesn\'t raise an error' do
        expect do
          subject.validate!(version: 1)
        end.not_to raise_error
      end
    end

    context 'when adding random properties' do
      it 'raises a validation error' do
        expect do
          subject.validate!(version: 1, random: 'value')
        end.to raise_error(DDSL::SchemaValidator::InvalidError)
      end
    end

    context 'when a build is given' do
      context 'when required properties are missing' do
        it 'raises a validation error' do
          expect do
            subject.validate!(
              version: 1,
              builds: [{}]
            )
          end.to raise_error(DDSL::SchemaValidator::InvalidError)
        end

        context 'when required properties are present' do
          let(:build) do
            {
              name: 'test',
              type: 'docker',
              context: '.',
              file: 'Dockerfile'
            }
          end

          it 'doesn\'t raise an error' do
            expect do
              subject.validate!(
                version: 1,
                builds: [build]
              )
            end.not_to raise_error
          end
        end
      end
    end

    context 'when a run is given' do
      context 'when required properties are missing' do
        it 'raises a validation error' do
          expect do
            subject.validate!(
              version: 1,
              runs: [{}]
            )
          end.to raise_error(DDSL::SchemaValidator::InvalidError)
        end

        context 'when type is docker' do
          context 'when required properties are missing' do
            it 'raises a validation error' do
              expect do
                subject.validate!(
                  version: 1,
                  runs: [{}]
                )
              end.to raise_error(DDSL::SchemaValidator::InvalidError)
            end
          end

          context 'when required properties are present' do
            context 'when type is docker' do
              let(:run) do
                {
                  type: 'docker',
                  image: 'docker/docker'
                }
              end

              it 'doesn\'t raise an error' do
                expect do
                  subject.validate!(
                    version: 1,
                    runs: [run]
                  )
                end.not_to raise_error
              end
            end

            context 'when type is docker-compose' do
              let(:run) do
                {
                  type: 'docker-compose',
                  service: 'test_service'
                }
              end
              it 'doesn\'t raise an error' do
                expect do
                  subject.validate!(
                    version: 1,
                    runs: [run]
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
