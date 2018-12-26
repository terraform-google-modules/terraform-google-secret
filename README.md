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
Note this is all on a per environment basis as well.

## Usage
Examples are included in the [examples](./examples/) folder.

There are two key operations, creating the buckets, and fetching a secret. 
Note that setting/storing a secret is a separate and out-of-band process. See [this readme for more information.](./secret-infrastructure/infra/README.md)

The base module is to fetch a secret from already created buckets. 

### Fetching a secret
A simple example to fetch a secret is as follows: 

```hcl
module "fetch-secret" {
  source = "./"
  env = "${var.env}"
  application_name = "${var.application_name}"
  secret = "${var.secret}"
  credentials_file_path = "${var.credentials_file_path}"
}
```
#### Variables
To control module's behavior, change variables' values regarding the following:

- `env`: This is the value of the environment you're fetching a secret in.
- `application_name`: The name of the application you're fetching a secret for.
- `secret`: The name of the secret you're fetching (e.g. "api-key")
- `credentials_file_path`: The path to the service account JSON for the Google provider.

Creating the bucket infrastructure is a submodule in this repo. 

### Creating the buckets

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

#### Variables
To control module's behavior, change variables' values regarding the following:

- `project_name`: The name of the project you're storing these secrets in. This name is also used for the shared secrets buckets.
- `application_list`: The list of applications you're storing secrets for. A bucket will be created per application per environment.
- `env_list`: The list of environments you're storing secrets for. As above, a bucket will be created per application per environment. A shared secret bucket will also be created for each environment.
- `credentials_file_path`: The path to the service account JSON for the Google provider.



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

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0
- [docker](https://docker.com)
- [openssl](https://www.openssl.org/) - This is only used to generate a random suffix for bucket names

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).


The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples/` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the repo's root directory with the name `service-account-credentials.json`.
 Note that running the repo's integration tests (make test_integration) will copy the service-account-credentials.json file the root to each submodule.
3. Run the tests. This will run the overall integration test, as well as the submodule integration tests.
    ```bash
       make test_integration
    ```
  
4. To run a specific submodule integration test, see the README for that module. To run the overall integration test, do
    ```bash
    	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME="sample-project-name" --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
    ```
5. This will build and run the kitchen tests for the module. If something fails, you might need to adjust the last line in the Dockerfile, as the image isn't fully built until that line passes.
6. Remove the kitchen call as needed, then connect to the docker tag for debugging.
    ```bash
       docker run -it -v $PWD:/root/live_workspace -e "PROJECT_NAME=sample-project-name" -w /root/live_workspace ubuntu-test-kitchen-terraform
    ```

    The module root directory will be loaded into the Docker container at `/root/live_workspace/`.
    Run kitchen-terraform to test the infrastructure:
    
    1. `kitchen create` creates Terraform state and downloads modules, if applicable.
    2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
    3. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
    4. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

#### Test configuration

You must set the project name as an environment variable before running the tests. 
```bash
    export PROJECT_NAME="sample-project-name"
```

A random suffix of characters is also applied to bucket names to provide uniqueness in the tests, as GCS bucket names must be globally unique.

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