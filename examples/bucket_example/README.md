This example shows how to use this module to create the GCS bucket infrastructure that will be used to store secrets.

This will create buckets with of the form: appname-env-secrets

It will also create the shared buckets (per environment)
* shared-projectname-dev-secrets
* shared-projectname-qa-secrets
* shared-projectname-prod-secrets

Specific submodule docs can be found [in the submodule](../../modules/secret-infrastructure/README.md)

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_list | The list of application names that will store secrets | list | `<list>` | no |
| credentials\_file\_path | GCP credentials fils | string | n/a | yes |
| env\_list | The list of environments for secrets | list | `<list>` | no |
| project\_name | The name of the project this applies to | string | n/a | yes |

[^]: (autogen_docs_end)