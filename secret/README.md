# terraform-gcp-get-gcs-object

This is a module to fetch an object in a GCS bucket. A listing of all secrets available can be found in the [`secrets`](./secrets) directory.

## Usage
There are multiple examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "mysecret" {
    source = "../../"
    application_name = "my-app"
    env = "dev"
    secret = "my-secret-name"
}
```

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application_name | The application to fetch secrets for | string | - | yes |
| shared | Will we fetch the secret from the shared bucket instead of an application-specific bucket? | string | `false` | no |
| env | The environment to fetch secrets for | string | - | yes |
| secret | The name of the secret to fetch | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| value | The value of the requested secret |

[^]: (autogen_docs_end)

## Managing Secrets
Setting secrets is done using bash scripts stored in the [scripts](./scripts/) directory.

### Requirements
To set secrets, you must have:

- [The gcloud sdk](https://cloud.google.com/sdk/install)
- A user account within appropriate permissions)
- [jq](https://stedolan.github.io/jq/) 1.5

Before running the scripts, you should authenticate gcloud:

```
gcloud auth login
```

### Setting Secrets
Application secrets are set using the following inputs:

- APPLICATION_NAME (ex. `sirius`)
- ENVIRONMENT (ex. `dev`)
- SECRET_NAME is the key the secret will be referenced by (ex. `my-secret`)
- SECRET_VALUE is the value of the secret (ex. `my-secret-value`)

The script is executed like this:

```
./scripts/set-secret.sh APPLICATION_NAME ENVIRONMENT SECRET_NAME SECRET_VALUE
```

For example:
```
./scripts/set-secret.sh sirius dev my-secret my-secret-name
```

Shared secrets which are referenced by multiple applications are set the same way, simply using `shared` as the application name. For example:

```
./scripts/set-secret.sh shared dev datadog-key the-datadog-secret-key
```

Multiple secrets can be set at once using the [`set-secrets.sh`](./scripts/set-secrets.sh) script, which accepts a JSON file (syntax example in [`secrets.json`](./examples/secrets.json)).

```
./scripts/set-secrets.sh examples/secrets.json
```

### Clearing Secrets
Secrets which are no longer needed should be cleared using the secret clearing sript:

```
./scripts/clear-secret.sh APPLICATION_NAME ENVIRONMENT SECRET_NAME
```

### Listing Secrets
A listing of all secrets managed by this module is included in the [`secrets`](./secrets) folder. This listing is generated automatically with this command:

```
./scripts/list-secrets.sh
```

**Note:** Secrets may need to be updated from an external process

## Development
### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```
