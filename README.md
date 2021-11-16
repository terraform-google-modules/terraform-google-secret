# [Google Cloud Storage secret management Terraform Module](https://registry.terraform.io/modules/terraform-google-modules/secret/google/)

## ⚠ Deprecated

This module has been deprecated. Please use [Secret Manager](https://cloud.google.com/secret-manager) for managing secrets and associated [Terraform resources](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret).

This Terraform module makes it easier to manage to manage secrets for your Google Cloud environment, such as api keys, tokens, etc.

Specifically, this repo provides modules to store secrets in app specific GCS buckets, shared buckets, and to fetch the secrets as needed.
Note this is all on a per environment basis as well.

## Usage
Examples are included in the [examples](./examples/) folder.

There are two key operations, creating the buckets, and fetching a secret. 
Note that setting/storing a secret is a separate and out-of-band process. See [this readme for more information.](./modules/secret-infrastructure/infra/README.md)

The base module is to fetch a secret from already created buckets. Submodules are for fetching a file from GCS, and creating the buckets.
The GCS fetching submodule is located at [./modules/secret-infrastructure](./modules/secret-infrastructure)
The bucket creation submodule is located at [./modules/secret-infrastructure](./modules/secret-infrastructure)

### Fetching a secret
A simple example to fetch a secret is as follows: 

```hcl
module "secret-fetch" {
  source  = "terraform-google-modules/secret/google"
  version = "0.1.0"

  env = "dev"
  application_name = "app1"
  secret = "api-key"
  credentials_file_path = "service-account-credentials.json"
}
```

Creating the bucket infrastructure is a submodule in this repo. 

### Creating the buckets

A simple example to create buckets is as follows:

```hcl
module "secret-storage" {
  source  = "terraform-google-modules/secret/google//modules/secret-infrastructure"
  version = "0.1.0"

  project_name = "your-secret-storage-project"
  application_list = ["webapp", "service1"]
  env_list = ["dev", "qa", "production"]
  credentials_file_path = "service-account-credentials.json"
}
```

This will create buckets with of the form: appname-env-secrets
Using the above as an example, this will create:
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

Specific submodule docs can be found [in the submodule](secret-infrastructure/README.md)

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
| contents | The actual value of the requested secret |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) v1.10.0

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

### Terraform plugins

- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) v1.10.0


## Development

### File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /test: Folders with files for testing the module (see Testing section on this file)
- /main.tf: main file for this module, contains primary logic for operate the module
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /readme.MD: this file
- /modules: submodules. See individual modules for README's.

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `credentials.json`.
3. Build the Docker containers for testing:

  ```
  CREDENTIALS_FILE="credentials.json" make docker_build_terraform
  CREDENTIALS_FILE="credentials.json" make docker_build_kitchen_terraform
  ```
4. Run the testing container in interactive mode:

  ```
  make docker_run
  ```

  The module root directory will be loaded into the Docker container at `/cftk/workdir/`.
5. Run kitchen-terraform to test the infrastructure:

  1. `kitchen create` creates Terraform state and downloads modules, if applicable.
  2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
  3. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
  4. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `CREDENTIALS_FILE="credentials.json"  make test_integration_docker` to run all the test steps non-interactively.

#### Test configuration

Each test-kitchen instance is configured with a `terraform.tfvars` file in the test fixture directory, e.g. `test/fixtures/fetch-secret/terraform.tfvars`.
Similarly, each test fixture has a `variables.tf` to define these variables, and an `outputs.tf` to facilitate providing necessary information for `inspec` to locate and query against created resources.

For running the test fixture in docker `make test_integration_docker`, set the variable `credentials_file_path` to your filename as above, but with the path as follows 
`credentials_file_path="/cftk/workdir/credentials.json`
``

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

The -s is for 'silent'. Successful output looks like this, though there are currently failing files.

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
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew


## Setting secrets concepts
In general, this repo is built to run in CI/CD. It's not usually appropriate to have the setting of secrets performed in that manner.

The helpers/ directory has a basic concept for setting secrets. The code is here doesn't run as-is (bucket names will need to be adjusted, etc), but is provided as a way to think about setting secrets.
Conceptually, secrets are set manually by a team authorized to perform this work. 

The team would use the `helpers/set-secrets.sh` script to set the secret (see [below](#setting-secrets)). 

In this scenario, the GCS buckets are the source of truth. It might be necessary to have a list of the secrets stored in source control for auditability. See [jenkins](#jenkins-automation). 

### File structure
The helpers directory has the following folders and files:

- helpers/ - Contains the helper scripts for setting/clearing scripts (set/list/clear-secret.sh, set-secrets.sh)
- helpers/jenkins - Contains an example Jenkins Groovy for capturing defined secret names in source 


### Setting Secrets
Application secrets are set using the following inputs:

- APPLICATION_NAME (ex. `app1`)
- ENVIRONMENT (ex. `dev`)
- SECRET_NAME is the key the secret will be referenced by (ex. `my-secret`)
- SECRET_VALUE is the value of the secret (ex. `my-secret-value`)

The script is executed like this:

```
./helpers/set-secret.sh APPLICATION_NAME ENVIRONMENT SECRET_NAME SECRET_VALUE
```

For example:
```
./helpers/set-secret.sh app1 dev my-secret my-secret-name
```

Shared secrets which are referenced by multiple applications are set the same way, simply using `shared` as the application name. For example:

```
./helpers/set-secret.sh shared dev datadog-key the-datadog-secret-key
```

Multiple secrets can be set at once using the [`set-secrets.sh`](./helpers/set-secrets.sh) script, which accepts a JSON file (syntax example in [`secrets.json`](./examples/secrets.json)).

```
./helpers/set-secrets.sh examples/secrets.json
```

### Clearing Secrets
Secrets which are no longer needed should be cleared using the secret clearing sript:

```
./helpers/clear-secret.sh APPLICATION_NAME ENVIRONMENT SECRET_NAME
```

### Listing Secrets
A listing of all secrets managed by this module is generated with this command:

```
./helpers/list-secrets.sh
```

### Jenkins automation

[./helpers/jenkins](./helpers/jenkins) is a pipeline with the goal of having an up to date capture of the defined secrets in source. The groovy script is triggered in Jenkins (via cron).
This script calls [list-secrets.sh](./helpers/list-secrets.sh), which fetches all the defined secrets. It then calls [commit-list.sh](./helpers/jenkins/commit-list.sh) to commit them to source control. All three of these files will need modification to work correctly in your environments. 

```
./helpers/jenkins/default-update-secrets-list.groovy
```

```
./helpers/jenkins/commit-list.sh
```
