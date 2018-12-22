# terraform-google-secret

secrets live in their own project 
  name must be configured in the groovy file, and in terraform vars
  document groovy file / jenkins infrastructure
buckets are per app and per environment
openssl used for random string
service-account-credentials.json
ENV var for project name (simple-sample-project-cae8)

# Google Cloud GCS based secret management Terraform Module

This Terraform module makes it easier to manage to manage secrets for your Google Cloud environment.
Think api keys, tokens, etc.

Specifically, this repo provides modules to store secrets in app specific GCS buckets, shared buckets, and to fetch the secrets as needed.
Note this is all on a per environment basis.

## Usage
Examples are included in the [examples](./examples/) folder.

There are two key operations, creating the buckets, and fetching a secret.

A simple example to create buckets is as follows:

```hcl
module "secret-storage" {
  source = "./secret-infrastructure"
  project_name = "your-secret-storage-project"
  application_list = ["webapp", "service1"]
  env_list = ["dev", "qa", "production"]
  credentials_file_path = "service-account-creds.json"
}
```
This will create buckets with of the form: appname-env-secrets
Using the above as an example, you'll create:
* webapp-dev-secrets
* webapp-qa-secrets
* webapp-prod-secrets
* service1-dev-secrets
* service1-qa-secrets
* service1-prod-secrets

Along with the shared buckets per environment
* shared-projectname-dev-secrets
* shared-projectname-qa-secrets
* shared-projectname-prod-secrets

### Variables
To control module's behavior, change variables' values regarding the following:

- `constraint`: set this variable with the [constraint value](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints#available_constraints) in the form `constraints/{constraint identifier}`. For example, `constraints/serviceuser.services`
- `policy_type`: Specify either `boolean` for boolean policies or `list` for list policies. (default `list`)
- Policy Root: set one of the following values to determine where the policy is applied:
  - `organization_id`
  - `project_id`
  - `folder_id`
- `exclude_folders`: a list of folder IDs to be excluded from this policy. These folders must be lower in the hierarchy than the policy root.
- `exclude_projects`: a list of project IDs to be excluded from this policy. They must be lower in the hierarchy than the policy root.
- Boolean policies (with `policy_type: "boolean"`) can set the following variables:
  - `enforce`: if "true" the policy is enforced at the root, if "false" the policy is not enforced at the root. (default `true`)
- List policies (with `policy_type: "list"`) can set **one of** the following variables. Only one may be set.
  - `enforce`: if "true" policy will deny all, if "false" policy will allow all (default `true`)
  - `allow`: list of values to include in the policy with ALLOW behavior
  - `deny`: list of values to include in the policy with DENY behavior
- List policies with allow or deny values require the length to be set ( a workaround for [this terraform issue](https://github.com/hashicorp/terraform/issues/10857))
  - `allow_list_length`
  - `deny_list_length`

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_name | The application to fetch secrets for | string | - | yes |
| credentials\_file\_path | The path to the GCP credentials | string | - | yes |
| env | The environment to fetch secrets for | string | - | yes |
| secret | The name of the secret to fetch | string | - | yes |
| shared | Will we fetch the secret from the shared bucket instead of an application-specific bucket? | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| contents | The contents of the requested GCS object |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) v1.10.0

### Permissions
In order to execute this module, the Service Account you run as must have the **Organization Policy Administrator** (`roles/orgpolicy.PolicyAdmin`) role.

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

### Terraform plugins

- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) v1.10.0


### Fast install (optional)
For a fast install, please configure the variables on init_centos.sh  or init_debian.sh script and then launch it.

The script will do:
- Environment variables setting
- Installation of base packages like wget, curl, unzip, gcloud, etc.

## Development

### File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /test: Folders with files for testing the module (see Testing section on this file)
- /main.tf: main file for this module, contains primary logic for operate the module
- /*_constraints.tf: files for manage the policy resources
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /readme.MD: this file

### Requirements
- [bats](https://github.com/sstephenson/bats) 0.4.0
- [jq](https://stedolan.github.io/jq/) 1.5
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Integration tests
The integration tests for this module are built with bats, basically the test checks the following:
- Perform `terraform init` command
- Perform `terraform get` command
- Perform `terraform plan` command and check that it'll create *n* resources, modify 0 resources and delete 0 resources
- Perform `terraform apply -auto-approve` command and check that it has created the *n* resources, modified 0 resources and deleted 0 resources
- Perform several `gcloud` commands and check the policies are in the desired state
- Perform `terraform destroy -force` command and check that it has destroyed the *n* resources

Please edit the *test/integration/<list|boolean>_constraints/launch.sh* files in order to specify the test beahvior

You can use the following command to run the integration tests in the folder */test/integration/<list|boolean>_constraints/*

  `. launch.sh`

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running gofmt
Running terraform validate
Running hadolint on Dockerfiles
Test passed - Verified all file Apache 2 headers
```

The linters
are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew