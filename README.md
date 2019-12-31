# [Google Cloud Storage secret management Terraform Module](https://registry.terraform.io/modules/terraform-google-modules/secret/google/)

This Terraform module makes it easier to manage secrets for your Google Cloud environment, such as api keys, tokens, etc.

Specifically, this repo provides modules to store secrets in app specific GCS buckets, shared buckets, and to fetch the secrets as needed.
Note this is all on a per environment basis as well.

## Usage
Examples are included in the [examples](./examples/) folder.

There are three key operations, creating the buckets, storing the secret, and fetching a secret.

The base module is to fetch a secret from already created buckets. Submodules are for fetching a file from GCS, and creating the buckets.
The bucket creation submodule is located at [./modules/secret-infrastructure](./modules/secret-infrastructure)
The GCS fetching submodule is located at [./modules/gcs-object](./modules/gcs-object)
The secret creation submodule is located at [./modules/create-secret](./modules/create-secret)
More about `Setting secrets concepts` and scripts to help with, in [helpers/manage-secrets](./helpers/manage-secrets) directory.

### Fetching a secret
A simple example to fetch a secret is as follows:

```hcl
module "fetch-secret" {
  source  = "terraform-google-modules/secret/google"
  version = "1.0.0"
  project_id = "your-secret-storage-project"
  env = "dev"
  application_name = "app1"
  secret = "api-key"
//secret = "api-key.txt" <== is valid too

}
```


### Creating the buckets

A simple example to create buckets is as follows:

```hcl
module "secret-storage" {
  source  = "terraform-google-modules/secret/google//modules/secret-infrastructure"
  version = "1.0.0"

  project_id = "your-secret-storage-project"
  application_list = ["webapp", "service1"]
  env_list = ["dev", "qa", "production"]
}
```

This will create buckets with of the form: appname-env-secrets
Using the above as an example, this will create:
* your-secret-storage-project-webapp-dev-secrets
* your-secret-storage-project-webapp-qa-secrets
* your-secret-storage-project-webapp-prod-secrets
* your-secret-storage-project-service1-dev-secrets
* your-secret-storage-project-service1-qa-secrets
* your-secret-storage-project-service1-prod-secrets

Along with the shared buckets per environment
* shared-your-secret-storage-project-dev-secrets
* shared-your-secret-storage-project-qa-secrets
* shared-your-secret-storage-project-prod-secrets

Specific submodule docs can be found [in the submodule](./modules/secret-infrastructure/README.md)

### Creating the secret

A simple example how to create applications secret is as follows:

```hcl
module "create_secret" {
  source  = "terraform-google-modules/secret/google//modules/create-secret"
  version = "1.0.0"

  application_name  = "app1"
  env               = "qa"
  secret            = "secret-example"
  content_file       = "/path/to/secret/file.txt"
  shared            = false
  project_id        = "your-secret-storage-project"
}
```

Specific submodule docs can be found [in the submodule](./modules/create-secret/README.md)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_name | The application to fetch secrets for | string | n/a | yes |
| env | The environment to fetch secrets for | string | n/a | yes |
| project\_id | The id of the project sectre buckets belong to | string | n/a | yes |
| secret | The name of the secret to fetch | string | n/a | yes |
| shared | Will we fetch the secret from the shared bucket instead of an application-specific bucket? | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| contents | The actual value of the requested secret |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform 0.11.x-compatible
version of this module, the last released version intended for Terraform 0.11.x
is [0.1.0][v0.1.0].

## Upgrading

The following guides are available to assist with upgrades:

- [0.1.0 -> 1.0.0](./docs/upgrading_to_1.0.0.md)

## Requirements
### Installed Software
- [Terraform](https://www.terraform.io/downloads.html) ~> 0.12.6
- [Terraform Provider for GCP](https://github.com/terraform-providers/terraform-provider-google) ~> 2.12
- [gcloud](https://cloud.google.com/sdk/gcloud/) >243.0.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the following roles:

- roles/storage.admin
- roles/iam.serviceAccountUser

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

- Cloud Storage API - storage-api.googleapis.com

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.
