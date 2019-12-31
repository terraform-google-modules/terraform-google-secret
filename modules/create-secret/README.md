# Create secret submodule

This submodule-helper isn't a part of the main `terraform-google-secret` module.
It could be used to create a secret, but also secret could be created manual, by API call, by google SDK,
or using [provided helper scripts](../../helpers/manage-secrets).

The submodule store `secret` from file on already created by [secret-infrastructure submodule](./secret-infrastructure) bucket in file `secret.txt` .
To store secret is used bucket with name:
* `${var.project_id}-${var.application_name-${var.env}-secrets` for application-specific secrets
* `shared-${var.project_id}-${var.env}-secrets` for shared secrets.


## Usage

Basic usage of this submodule is as follows:

* for application-specific secrets:
```hcl
module "create_secret" {
  source  = "terraform-google-modules/secret/google//modules/create-secret"
  version = "1.0.0"

  application_name  = "app1"
  env               = "qa"
  secret            = "secret1"
  content_file      = "${path.module}/secrets/secret1.txt"
  shared            = false
  project_id        = var.project_id
}
```

* for shared secrets:
```hcl
module "create_shared_secret" {
  source  = "terraform-google-modules/secret/google//modules/create-secret"
  version = "1.0.0"

  env               = "dev"
  secret            = "secret2.txt"
  content_file      = "${path.module}/secrets/secret2.txt"
  shared            = true
  project_id        = var.project_id
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_name | The application to create secret for. Could be EMPTY value for shared secrets | string | `""` | no |
| content\_file | The content file path | string | n/a | yes |
| env | The environment to create secret for | string | n/a | yes |
| module\_depends\_on | The workaround for module dependencies. For example, could be used to wait before the bucket is created | list | `<list>` | no |
| project\_id | The id of the project secret buckets belong to | string | n/a | yes |
| secret | The name of the secret to create. The both forms `secret_name` and `secret_name.txt` are valid | string | n/a | yes |
| shared | Will we push the secret to the shared bucket instead of an application-specific bucket? | bool | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| md5hash | Base 64 MD5 hash of the uploaded data. |
| secret\_name | The name of the object(file) the secret stored in |
| self\_link | A url reference to this object. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

