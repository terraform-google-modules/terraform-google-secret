# terraform-gcp-get-gcs-object
# object fetching for Google Cloud GCS based secret management Terraform Module

This submodule is part of the the `terraform-google-secret` module. It fetch content of an secret from a GCS bucket using temporary signed_url.

## Usage

Basic usage of this submodule is as follows:

```hcl

module "secret" {
  source  = "terraform-google-modules/secret/google//modules/gcs-object"
  version = "1.0.0"
  
  bucket = "your-secret-storage-project-webapp-dev-secrets"
  path   = "webapp-secret1"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
