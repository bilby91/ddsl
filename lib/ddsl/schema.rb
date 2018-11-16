# frozen_string_literal: true

module DDSL
  SchemaVersion = :draft4
  Schema = {
    type: :object,
    required: [:version],
    additionalProperties: false,
    properties: {
      version: {
        type: :integer,
        enum: [1]
      },
      builds: {
        type: :array,
        items: { '$ref': '#/definitions/build' }
      },
      runs: {
        type: :array,
        items: { '$ref': '#/definitions/run' }
      }
    },
    definitions: {
      build: {
        type: :object,
        required: [:name],
        allOf: [
          { "$ref": '#/definitions/build_options' }
        ],
        properties: {
          name: {
            type: :string
          }
        }
      },
      run: {
        type: :object,
        oneOf: [
          { "$ref": '#/definitions/run_docker_options' },
          { "$ref": '#/definitions/run_docker_compose_options' }
        ]
      },
      build_options: {
        type: :object,
        required: %i[context dockerfile],
        properties: {
          context: { type: :string },
          dockerfile: { type: :string },
          build_args: {
            type: :object,
            additionalProperties: {
              type: :string
            }
          },
          tags: {
            type: :array,
            items: { type: :string }
          },
          push: { type: :boolean }
        }
      },
      run_docker_options: {
        type: :object,
        required: %i[type image],
        properties: {
          type: {
            type: :string,
            enum: [:docker]
          },
          image: { type: :string },
          cmd: { type: :string },
          user: { type: :string },
          workdir: { type: :string },
          env: {
            type: :object,
            additionalProperties: {
              type: :string
            }
          },
          volumes: {
            type: :object,
            additionalProperties: {
              type: :string
            }
          }
        }
      },
      run_docker_compose_options: {
        type: :object,
        required: %i[type service],
        properties: {
          type: {
            type: :string,
            enum: [:'docker-compose']
          },
          service: { type: :string },
          cmd: { type: :string },
          user: { type: :string },
          workdir: { type: :string },
          env: {
            type: :object,
            additionalProperties: {
              type: :string
            }
          },
          volumes: {
            type: :object,
            additionalProperties: {
              type: :string
            }
          },
          service_ports: { type: :string }
        }
      }
    }
  }.freeze
end
