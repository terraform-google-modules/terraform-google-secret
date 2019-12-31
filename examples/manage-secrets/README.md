This example illustrates:
* how to use [secret-infrastructure](./modules/secret-infrastructure) submodule to create the GCS bucket infrastructure that will be used to store secrets
* how to create the secret and store it at the created bucket using submodule [create-secret](./modules/create-secret)
* how to use the main module to fetch the secret


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The id of the project to create buckets in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app\_buckets | The lists of created application-specific buckets |
| app\_secret | The actual value of the requested app-secret |
| shared\_buckets | The lists of created shared buckets |
| shared\_secret | The actual value of the requested shared secret |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

