This example illustrates:
* how to use [secret-infrastructure](./modules/secret-infrastructure) submodule to create the GCS bucket infrastructure that will be used to store secrets
* how to create multiply secrets and store it at the created buckets using submodule [create-secrets](./modules/create-secret)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The id of the project to create buckets in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app\_buckets | The lists of created application-specific buckets |
| shared\_buckets | The lists of created shared buckets |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

