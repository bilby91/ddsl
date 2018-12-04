# ddsl

Docker Declarative Specific Language

`ddsl` lets you declare how your docker images are built and what checks (test, linter, etc) need be run in your images.

```yaml
version: 1

builds:
  - name: feature-branch
    type: docker
    context: .
    file: docker/Dockerfile
    tags:
      - bilby91/ddsl:$CI_SHA1
    push: true
    cache_from:
      - bilby91/ddsl:latest
  - name: master-branch
    type: docker
    context: .
    file: docker/Dockerfile
    tags:
      - bilby91/ddsl:$CI_SHA1
      - bilby91/ddsl:latest
    push: true
    cache_from:
      - bilby91/ddsl:latest
  - name: dev
    type: docker-compose
    file: docker/docker-compose.yml

runs:
  - name: bash
    type: docker-compose
    file: docker/docker-compose.yml
    service: ddsl
    cmd: /bin/bash
  - name: test-ci
    type: docker
    image: bilby91/ddsl:$CI_SHA1
    cmd: bundle exec rspec spec
  - name: test
    type: docker
    image: bilby91/ddsl:latest
    cmd: bundle exec rspec spec
  - name: lint-ci
    type: docker
    image: bilby91/ddsl:$CI_SHA1
    cmd: rubocop .
  - name: lint
    type: docker
    image: bilby91/ddsl:latest
    cmd: rubocop .
```

## Contnious Integration

| Provider  | Status                                                                                                                                   |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------|
| GitLab CI | [![Gitlab CI](https://img.shields.io/gitlab/pipeline/bilby91/ddsl/master.svg)](https://gitlab.com/bilby91/ddsl)                          |
| Circle CI | [![Circle CI](https://img.shields.io/circleci/project/github/bilby91/ddsl/master.svg)](https://circleci.com/gh/bilby91/ddsl/tree/master) |
| Travis CI | [![Travis CI](https://img.shields.io/travis/bilby91/ddsl/master.svg)](https://travis-ci.com/bilby91/ddsl)                                |

## Dependencies

- ruby
- docker
- docker-compose

## TODO

- [X] Docker Compose support
- [X] Variable interpolation
- [X] Add CircleCI
- [X] Add GitLabCI
- [X] Add TravisCI
- [X] Registries?
- [ ] Variable sharing/reusing
- [ ] External secret proviers ? (KMS, Google?)

## Contact

- Martín Fernández <fmartin91@gmail.com>