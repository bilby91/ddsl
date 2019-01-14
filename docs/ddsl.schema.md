
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
| [builds](#builds) | Build | Optional |  | DDSL (this schema) |
| [registries](#registries) | Registry | Optional | `[]` | DDSL (this schema) |
| [runs](#runs) | Run | Optional |  | DDSL (this schema) |
| [templates](#templates) | Template | Optional |  | DDSL (this schema) |
| [version](#version) | `enum` | **Required** |  | DDSL (this schema) |

## builds

List of build tasks to run

`builds`

* is optional
* type: Build
* defined in this schema

### builds Type


Array type: Build

All items must be of the type:
* [Build](build.schema.md) – `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/build.schema.json`








## registries

List of registries to authenticate when performing either a build or run operation

`registries`

* is optional
* type: Registry

* default: `[]`
* defined in this schema

### registries Type


Array type: Registry

All items must be of the type:
* [Registry](registry.schema.md) – `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/registry.schema.json`








## runs

List of run tasks to run

`runs`

* is optional
* type: Run
* defined in this schema

### runs Type


Array type: Run

All items must be of the type:
* [Run](run.schema.md) – `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/run.schema.json`








## templates

List of templates to use in builds or runs

`templates`

* is optional
* type: Template
* defined in this schema

### templates Type


Array type: Template

All items must be of the type:
* [Template](template.schema.md) – `https://raw.githubusercontent.com/bilby91/ddsl/master/docs/template.schema.json`








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



