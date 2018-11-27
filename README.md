# ddsl

Docker Declarative Specific Language

`ddsl` lets you declare how your docker images are built and what checks (test, linter, etc) need be run in your images.

```yaml
version: 1

builds:
  - name: main
    context: .
    file: docker/Dockerfile
    tags:
      - bilby91/ddsl:latest

runs:
  - name: bash
    type: docker-compose
    file: docker/docker-compose.yml
    service: ddsl
    cmd: /bin/bash

  - name: test
    type: docker
    image: bilby91/ddsl:latest
    cmd: rspec spec .

  - name: lint
    type: docker
    image: bilby91/ddsl:latest
    cmd: rubocop .
```

## Dependencies

- ruby
- docker
- docker-compose

## TODO

- [X] Docker Compose support
- [ ] Variable interpolation
- [ ] Registries
- [ ] Build/Test DDSL using DDSL. Inception :)
- [ ] Variable sharing/reusing
- [ ] External secret proviers ? (KMS, Google?)

## Contact

- Martín Fernández <mfernandez@geofore.com>