
# DDSL Schema

```
https://raw.githubusercontent.com/bilby91/ddsl/master/docs/ddsl.schema.json
```

Schema for the DDSL file format.

| Abstract | Extensible | Status | Identifiable | Custom Properties | Additional Properties | Defined In |
|----------|------------|--------|--------------|-------------------|-----------------------|------------|
| Can be instantiated | No | Experimental | No | Forbidden | Forbidden | [ddsl.schema.json](ddsl.schema.json) |

# DDSL Properties

| Property | Type | Required | Default | Defined by |
|----------|------|----------|---------|------------|
| [builds](#builds) | reference | Optional |  | DDSL (this schema) |
| [registries](#registries) | reference | Optional | `[]` | DDSL (this schema) |
| [runs](#runs) | reference | Optional |  | DDSL (this schema) |
| [version](#version) | `enum` | **Required** |  | DDSL (this schema) |

## builds

List of build tasks to run

`builds`

* is optional
* type: reference
* defined in this schema

### builds Type


Array type: reference

All items must be of the type:
* []() – `https://raw.githubusercontent.com/bilby91/ddsl/testing/docs/build.schema.json`








## registries

List of registries to authenticate when performing either a build or run operation

`registries`

* is optional
* type: reference

* default: `[]`
* defined in this schema

### registries Type


Array type: reference

All items must be of the type:
* []() – `https://raw.githubusercontent.com/bilby91/ddsl/testing/docs/registry.schema.json`








## runs

List of run tasks to run

`runs`

* is optional
* type: reference
* defined in this schema

### runs Type


Array type: reference

All items must be of the type:
* []() – `https://raw.githubusercontent.com/bilby91/ddsl/testing/docs/run.schema.json`








## version

Version of the DDSL schema

`version`

* is **required**
* type: `enum`
* defined in this schema

The value of this property **must** be equal to one of the [known values below](#version-known-values).

### version Known Values
| Value | Description |
|-------|-------------|
| `1` |  |



