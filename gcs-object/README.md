# terraform-gcp-get-gcs-object
# object fetching for Google Cloud GCS based secret management Terraform Module

This is a submodule to fetch an object in a GCS bucket.

## Example usage
See the living [barebones](./examples/barebones-test-fixture) test fixture example for usage.

#### Variables
To control module's behavior, change variables' values regarding the following:

- `bucket`: The name of the bucket you're fetching from
- `path`: The path and file you're fetching
- `duration`:  The file is fetched by creating a signed URL. This specifies how long the the URL is valid for.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket | The bucket to fetch the object from | string | - | yes |
| duration | The duration of the signed URL (defaults to 1m) | string | `1m` | no |
| path | The path to the desired object within the bucket | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| contents | The contents of the requested GCS object |
| url | - |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) v1.10.0

### Permissions
In order to execute this module, you must have the roles and permissions for creating buckets.

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

### Terraform plugins

- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) v1.10.0

## Development

### File structure
The project has the following folders and files:

- ./gcs-object: root folder
- ./examples/barebones-test-fixture: example for using this module
- ./test: Folders with files for testing the module (see Testing section on this file)
- ./main.tf: main file for this module, contains primary logic for operate the module
- ./variables.tf: all the variables for the module
- ./outputs.tf: the outputs of the module
- ./readme.MD: this file

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
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `service-account-credentials.json`.
 Running the whole set of integration tests (from the repo root) is the recommended way of running the tests. Note that running the repo's integration tests (make test_integration) will copy the service-account-credentials.json file from the root to here.
3. To run this specific test, build and run the test in a Docker container (specify your project name in the build-arg):
    ```bash
	    docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=sample-project-name --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
    ```
  
4. This will build and run the kitchen tests for the module. If something fails, you might need to adjust the last line in the Dockerfile, as the image isn't fully built until that line passes.
5. Remove the kitchen call as needed, then connect to the docker tag for debugging.
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

A random suffix of characters is applied to bucket names to provide uniqueness in the tests, as GCS bucket names must be globally unique.

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