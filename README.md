# ddsl

Docker Declarative Specific Language

`ddsl` lets you declare how your docker images are built and what checks (test, linter, etc) need be run in your images.

```yaml
version: 1

builds:
  - name: main
    context: .
    dockerfile: docker/app/Dockerfile
    build_args:
      APP_ENV: production
    tags:
      - $IMAGE
    push: true

runs:
  - name: test
    type: docker-compose
    service: test
    cmd: /test.sh
  - name: lint
    type: docker-compose
    service: test
    cmd: /lint.sh
```

## Dependencies

- ruby
- docker
- docker-compose (optional)

## TODO

- [] Docker Compose support
- [] Build/Test DDSL using DDSL. Inception :)
- [] Registries
- [] Variable interpolation
- [] Variable sharing/reusing
- [] External secret proviers ? (KMS, Google?)

## Contact

- Martín Fernández <mfernandez@geofore.com>