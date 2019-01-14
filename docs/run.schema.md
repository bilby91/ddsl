
# Run Schema

```
https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json
```

Run task to perform using either docker or docker-compose

| Abstract | Extensible | Status | Identifiable | Custom Properties | Additional Properties | Defined In |
|----------|------------|--------|--------------|-------------------|-----------------------|------------|
| Can be instantiated | Yes | Experimental | No | Forbidden | Permitted | [run.schema.json](run.schema.json) |

# Run Properties

| Property | Type | Required | Defined by |
|----------|------|----------|------------|
| [name](#name) | `string` | **Required** | Run (this schema) |
| `*` | any | Additional | this schema *allows* additional properties |

## name

Unique name to identify the run task.

`name`

* is **required**
* type: `string`
* defined in this schema

### name Type


`string`







# Run Definitions

| Property | Type | Group |
|----------|------|-------|
| [cmd](#cmd) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [detach](#detach) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [env](#env) | `object` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [file](#file) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [image](#image) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_options` |
| [no_deps](#no_deps) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [rm](#rm) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [service](#service) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [service_ports](#service_ports) | `boolean` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [templates](#templates) | `string[]` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [type](#type) | `enum` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [user](#user) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [volumes](#volumes) | `string[]` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |
| [workdir](#workdir) | `string` | `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json#/definitions/run_docker_compose_options` |

## cmd

Command to run in the the container

`cmd`

* is optional
* type: `string`
* defined in this schema

### cmd Type


`string`







## detach

Detached mode: Run container in the background, print new container name

`detach`

* is optional
* type: `boolean`
* defined in this schema

### detach Type


`boolean`





## env

Set environment variables

`env`

* is optional
* type: `object`
* defined in this schema

### env Type


`object` with following properties:


| Property | Type | Required |
|----------|------|----------|






## file

Path to the docker-compose file

`file`

* is optional
* type: `string`
* defined in this schema

### file Type


`string`







## image

The image that the container will use

`image`

* is optional
* type: `string`
* defined in this schema

### image Type


`string`







## no_deps

Don't start linked services

`no_deps`

* is optional
* type: `boolean`
* defined in this schema

### no_deps Type


`boolean`





## rm

Remove container after run. Ignored in detached mode

`rm`

* is optional
* type: `boolean`
* defined in this schema

### rm Type


`boolean`





## service

Name of the docker-compose service to build

`service`

* is optional
* type: `string`
* defined in this schema

### service Type


`string`







## service_ports

Run command with the service's ports enabled and mapped to the host

`service_ports`

* is optional
* type: `boolean`
* defined in this schema

### service_ports Type


`boolean`





## templates

List of templates the run will inherit

`templates`

* is optional
* type: `string[]`
* defined in this schema

### templates Type


Array type: `string[]`

All items must be of the type:
`string`










## type

Type of runner to use

`type`

* is optional
* type: `enum`
* defined in this schema

The value of this property **must** be equal to one of the [known values below](#type-known-values).

### type Known Values
| Value | Description |
|-------|-------------|
| `docker-compose` |  |




## user

Run as specified username or uid

`user`

* is optional
* type: `string`
* defined in this schema

### user Type


`string`







## volumes

Bind mount volumes

`volumes`

* is optional
* type: `string[]`
* defined in this schema

### volumes Type


Array type: `string[]`

All items must be of the type:
`string`










## workdir

Working directory inside the container

`workdir`

* is optional
* type: `string`
* defined in this schema

### workdir Type


`string`






