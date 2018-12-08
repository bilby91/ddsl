# ddsl

> Docker Declarative Specific Language

`ddsl` allow developers to express in a declarative way how application are built, run and tested. Building, running and testing applications should be semlessly, independently on what environment your are. `ddsl` makes the latter easy by providing one cli to use in CI and development environments.

## Dependencies

- ruby
- docker
- docker-compose

## Installation

You can install `ddsl` with either of this mechansims

### Gem

Like any ruby gem

`gem install ddsl`

### Docker

When running on modern CI providers like [Circle CI](https://circleci.com) or [GitLab](https://gitlab.com) you can install it using the docker image `bilby91/ddsl:latest`. You can find more information on how to use it by looking at ddsl's [Circle CI implementation](https://github.com/bilby91/ddsl/blob/master/.circleci/config.yml) or [GitLab implementation](https://github.com/bilby91/ddsl/blob/master/.gitlab-ci.yml)

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

runs:
  - name: test
    type: docker
    image: bilby91/ddsl:$CI_SHA1
    cmd: bundle exec rspec spec

  - name: lint
    type: docker
    image: bilby91/ddsl:$CI_SHA1
    cmd: rubocop .
```

### Build

In order to run our feature-branch build we invoke

`ddsl build feature-branch`

### Run

Now that we have our image built we can run things on it

`ddsl run test lint`

### Environment Variables

- [ ] TODO

## Documentation

For the moment, looking at how `ddsl` uses itself is the best documentation. You can find it here [`.ddsl.yml`](https://github.com/bilby91/ddsl/blob/master/.ddsl.yml).

You can also look at how `ddsl` integrates with different CI providers

- [Circle CI](https://github.com/bilby91/ddsl/blob/master/.circleci/config.yml) 
- [GitLab](https://github.com/bilby91/ddsl/blob/master/.gitlab-ci.yml)
- [Travis](https://github.com/bilby91/ddsl/blob/master/.travis.yml)

### Schema

The `.ddsl.yml` schema [documentation](https://github.com/bilby91/ddsl/blob/master/docs/ddsl.schema.md) can found [here](https://github.com/bilby91/ddsl/blob/master/docs/ddsl.schema.md) 

## Continuous Integration

| Provider  | Status                                                                                                                                   |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------|
| GitLab CI | [![Gitlab CI](https://img.shields.io/gitlab/pipeline/bilby91/ddsl/master.svg)](https://gitlab.com/bilby91/ddsl)                          |
| Circle CI | [![Circle CI](https://img.shields.io/circleci/project/github/bilby91/ddsl/master.svg)](https://circleci.com/gh/bilby91/ddsl/tree/master) |
| Travis CI | [![Travis CI](https://img.shields.io/travis/com/bilby91/ddsl/master.svg)](https://travis-ci.com/bilby91/ddsl)                                |
## Contact

- Martín Fernández <fmartin91@gmail.com>
- Iván Etchart <ivan.etchart@me.com>
