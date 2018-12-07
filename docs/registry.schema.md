
# Registry Schema

```
https://raw.githubusercontent.com/bilby91/ddsl/master/docs/registry.schema.json
```

Information to authenticate with a docker registry

| Abstract | Extensible | Status | Identifiable | Custom Properties | Additional Properties | Defined In |
|----------|------------|--------|--------------|-------------------|-----------------------|------------|
| Can be instantiated | No | Experimental | No | Forbidden | Permitted | [registry.schema.json](registry.schema.json) |

# Registry Properties

| Property | Type | Required | Defined by |
|----------|------|----------|------------|
| [password](#password) | `string` | **Required** | Registry (this schema) |
| [url](#url) | `string` | **Required** | Registry (this schema) |
| [use_cache](#use_cache) | `boolean` | Optional | Registry (this schema) |
| [username](#username) | `string` | **Required** | Registry (this schema) |
| `*` | any | Additional | this schema *allows* additional properties |

## password

The docker registry username's password

`password`

* is **required**
* type: `string`
* defined in this schema

### password Type


`string`







## url

The docker registry server url. If using hub.docker.com as registry use `docker.io`

`url`

* is **required**
* type: `string`
* defined in this schema

### url Type


`string`







## use_cache

True if you want to reuse stored credentials under ~/.docker/config.json, false otherwise.

`use_cache`

* is optional
* type: `boolean`
* defined in this schema

### use_cache Type


`boolean`





## username

The docker registry username

`username`

* is **required**
* type: `string`
* defined in this schema

### username Type


`string`






