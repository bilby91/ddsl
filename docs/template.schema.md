
# Template Schema

```
https://raw.githubusercontent.com/bilby91/ddsl/master/docs/template.schema.json
```

Template for encapsulating common option either docker or docker-compose

| Abstract | Extensible | Status | Identifiable | Custom Properties | Additional Properties | Defined In |
|----------|------------|--------|--------------|-------------------|-----------------------|------------|
| Can be instantiated | No | Experimental | No | Forbidden | Permitted | [template.schema.json](template.schema.json) |

# Template Properties

| Property | Type | Required | Defined by |
|----------|------|----------|------------|
| [name](#name) | `string` | **Required** | Template (this schema) |
| `*` | any | Additional | this schema *allows* additional properties |

## name

Unique name to identify the template.

`name`

* is **required**
* type: `string`
* defined in this schema

### name Type


`string`






