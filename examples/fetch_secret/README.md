This example fetches the named secret given the appropriate application name, environment, and credentials file.


Specific submodule docs can be found [in the submodule](../../modules/gcs-object/README.md)

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_name | The application to fetch secrets for | string | - | yes |
| credentials\_file\_path | GCP credentials fils | string | - | yes |
| env | The environment to fetch secrets for | string | - | yes |
| secret | The name of the secret to fetch | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| mysecret | The actual value of the requested secret |

[^]: (autogen_docs_end)