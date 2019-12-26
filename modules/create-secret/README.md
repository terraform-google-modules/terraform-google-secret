# Create secret submodule

This submodule-helper isn't a part of the the main `terraform-google-secret` module.
It could be used to create a secret, but also secret could be created manual, by API call, by google SDK,
or using [provided helper scripts](../../helpers/manage-secrets).

The submodule store `secret` from file `var.content_file` on already created by [secret-infrastructure submodule](./secret-infrastructure) bucket in file `secret.txt` . 
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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
