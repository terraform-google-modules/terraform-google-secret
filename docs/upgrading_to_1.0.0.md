# Upgrading to 1.0.0

The 1.0.0 release is a backward incompatible release.
The mandatory string variable `credentials_file_path` hardcoded the google provider configuration, don't need anymore.
Follow [Google Provider Configuration Reference](https://www.terraform.io/docs/providers/google/guides/provider_reference.html)
to configure the google provider for the project.
Also, the `project_name` variable was renamed to `project_id`. And now that mandatory variable used as a prefix to form application-specific secrets bucket names


## Migration Instructions

For migration to 1.0.0 version,  set the mandatory `project_id` input with a project_id secrets buckets belong to
and discharged input `credentials_file_path` are needed.

Pay attention, by migration all old application-specific secret storage buckets will be destroyed and re-created with new names.
So, backup of all contents before the migration of the `secret-infrastructure` module and restore to new buckets is strongly recommended.

```diff
module "secret-storage" {
  source  = "terraform-google-modules/secret/google//modules/secret-infrastructure"
- version = "0.1.0"
+ version = "1.0.0"

- project_name = "your-secret-storage-project"
+ project_id = "your-secret-storage-project"
  application_list = ["webapp", "service1"]
  env_list = ["dev", "qa", "production"]
- credentials_file_path = "sservice-account-credentials.json"
}
```

```diff
module "fetch-secret" {
  source  = "terraform-google-modules/secret/google"
- version = "0.1.0"
+ version = "1.0.0"

  env = "dev"
  application_name = "app1"
  secret = "api-key"
- credentials_file_path = "sservice-account-credentials.json"
}
```
