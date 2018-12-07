
# Build Schema

```
https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json
```

Build task to perform using either docker or docker-compose

| Abstract | Extensible | Status | Identifiable | Custom Properties | Additional Properties | Defined In |
|----------|------------|--------|--------------|-------------------|-----------------------|------------|
| Can be instantiated | Yes | Experimental | No | Forbidden | Permitted | [build.schema.json](build.schema.json) |

# Build Properties

| Property | Type | Required | Defined by |
|----------|------|----------|------------|
| [name](#name) | `string` | **Required** | Build (this schema) |
| `*` | any | Additional | this schema *allows* additional properties |

## name

Unique name to identify the build task.

`name`

* is **required**
* type: `string`
* defined in this schema

### name Type


`string`







# Build Definitions

| Property | Type | Group |
|----------|------|-------|
| [build_args](#build_args) | `object` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [cache_from](#cache_from) | `string[]` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_options` |
| [compress](#compress) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [context](#context) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_options` |
| [file](#file) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [force_rm](#force_rm) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [labels](#labels) | `string[]` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_options` |
| [memory](#memory) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [no_cache](#no_cache) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [parallel](#parallel) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [pull](#pull) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [push](#push) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_options` |
| [service](#service) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |
| [tags](#tags) | `string[]` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_options` |
| [type](#type) | `enum` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json#/definitions/build_docker_compose_options` |

## build_args

Set build-time variables for services

`build_args`

* is optional
* type: `object`
* defined in this schema

### build_args Type


`object` with following properties:


| Property | Type | Required |
|----------|------|----------|






## cache_from

Images to consider as cache sources

`cache_from`

* is optional
* type: `string[]`
* defined in this schema

### cache_from Type


Array type: `string[]`

All items must be of the type:
`string`










## compress

Compress the build context using gzip

`compress`

* is optional
* type: `boolean`
* defined in this schema

### compress Type


`boolean`





## context

Path for the `docker build` context

`context`

* is optional
* type: `string`
* defined in this schema

### context Type


`string`







## file

Path to the docker-compose file

`file`

* is optional
* type: `string`
* defined in this schema

### file Type


`string`







## force_rm

Always remove intermediate containers

`force_rm`

* is optional
* type: `boolean`
* defined in this schema

### force_rm Type


`boolean`





## labels

Set metadata for an image

`labels`

* is optional
* type: `string[]`
* defined in this schema

### labels Type


Array type: `string[]`

All items must be of the type:
`string`










## memory

Sets memory limit for the build container.

`memory`

* is optional
* type: `string`
* defined in this schema

### memory Type


`string`







## no_cache

Do not use cache when building the image

`no_cache`

* is optional
* type: `boolean`
* defined in this schema

### no_cache Type


`boolean`





## parallel

Build images in parallel

`parallel`

* is optional
* type: `boolean`
* defined in this schema

### parallel Type


`boolean`





## pull

Always attempt to pull a newer version of the image

`pull`

* is optional
* type: `boolean`
* defined in this schema

### pull Type


`boolean`





## push

If true, push any configured tag to the appropiate registry

`push`

* is optional
* type: `boolean`
* defined in this schema

### push Type


`boolean`





## service

Name of the docker-compose service to build

`service`

* is optional
* type: `string`
* defined in this schema

### service Type


`string`







## tags

Name and optionally a tag in the ‘name:tag’ format

`tags`

* is optional
* type: `string[]`
* defined in this schema

### tags Type


Array type: `string[]`

All items must be of the type:
`string`










## type

Type of builder to use

`type`

* is optional
* type: `enum`
* defined in this schema

The value of this property **must** be equal to one of the [known values below](#type-known-values).

### type Known Values
| Value | Description |
|-------|-------------|
| `docker-compose` |  |



