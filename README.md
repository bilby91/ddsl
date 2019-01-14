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

If you want to inject environmental variables in your build or run definition it's really easy with `ddsl`. You just need to interpolate the environmental variable name in your `.ddsl.yml` file like you would do
in a bash script in order to get them injected.

Lets take a look at a section of the previous example:

```
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
```

In this case, our feature-branch build depends on the `CI_SHA1` enviromental variable. When invoking `CI_SHA1=XXXX ddsl build feature-branch`, ddsl will replace `CI_SHA1` with the appropiate value (in this case, XXXX) and continue it's normal work.

### Templates

Templates let you [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) your `.ddsl.yml` configurations. If you have multiple builds in your project, templates will be very useful for encapsulating common options that all or some of your builds need. Templates can be used in either builds or runs.

Lets take a look at a possible scenario where using templates would make sense.

```
version: 1

templates:
  - name: base-build
    context: .
    file: docker/Dockerfile
    push: true
    tags:
      - bilby91/ddsl:$CI_SHA1
    cache_from:
      - bilby91/ddsl:latest

builds:
  - name: feature-branch
    type: docker
    templates:
      - base-build

  - name: master
    type: docker
    templates:
      - base-build
    tags:
      - bilby91/ddsl:latest
```

In the example above we have introduced a new build called master. We have encapsulated all the common options between master and feature-branch in a template called base-build. When ddsl runs either feature-branch or master builds it will merge the options from the template into each build's options.

Some important things to note in regards to templates implementation:

If the templateable object (either a build or a run) have the same key defined, ddsl will behave like this:

1. If the key's value is either a string or a number, the templetable object value will be favored. This allows overriding certain keys when inheriting from a template.
2. If the key's value is an array, the template items of the array will be added to the templatable object array.
3. If the key's value is a map, the template items of the map will be merged in the templatable object map.
    1. If we have a collision here, `ddsl` will behave like described in point 1.

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
