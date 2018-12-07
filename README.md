# ddsl

Docker Declarative Specific Language

`ddsl` allow developers to express in a declarative way how application are built, run and tested. Building, running and testing applications should be semlessly, independently on what environment your are. `ddsl` makes the latter easy by providing one cli to use in CI and development environments.

## Usage

`ddsl` it's a command line tool that works with a companion `.ddsl.yml` file. In the `.ddsl.yml` file you can declare the diferent builds and runs that your application will need. A very simple example would look like this:

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

In order to run the `feature-branch` build for example, you would need to invoke the `ddsl` like this:

`ddsl build feature-branch`

Or maybe you want to run you tests

`ddsl run test`

Or maybe you want to run your tests and also lint your code

`ddsl run test lint`

## Documentation

The best documentation at this moment is looking at the source code of the project. `ddsl` uses itself to run in CI and developers use it to run in their development environments. Take a look at `.ddsl.yml` file in the root of the repository for more information.

Full documentation of the schema can be found here https://github.com/bilby91/ddsl/blob/master/docs/ddsl.schema.md

## Contnious Integration

| Provider  | Status                                                                                                                                   |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------|
| GitLab CI | [![Gitlab CI](https://img.shields.io/gitlab/pipeline/bilby91/ddsl/master.svg)](https://gitlab.com/bilby91/ddsl)                          |
| Circle CI | [![Circle CI](https://img.shields.io/circleci/project/github/bilby91/ddsl/master.svg)](https://circleci.com/gh/bilby91/ddsl/tree/master) |
| Travis CI | [![Travis CI](https://img.shields.io/travis/com/bilby91/ddsl/master.svg)](https://travis-ci.com/bilby91/ddsl)                                |

## Dependencies

- ruby
- docker
- docker-compose

## Contact

- Martín Fernández <fmartin91@gmail.com>
- Iván Etchart <ivan.etchart@me.com>