# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

all: check_shell check_python check_terraform check_docker check_base_files test_check_headers check_headers check_trailing_whitespace generate_docs ## Run all linters and update documentation

# The .PHONY directive tells make that this isn't a real target and so
# the presence of a file named 'check_shell' won't cause this target to stop
# working
.PHONY: check_shell
check_shell: ## Lint shell scripts
	@source test/make.sh && check_shell

.PHONY: check_python
check_python: ## Lint Python source files
	@source test/make.sh && check_python

.PHONY: check_golang
check_golang: ## Lint Go source files
	@source test/make.sh && golang

.PHONY: check_terraform
check_terraform: ## Lint Terraform source files
	@source test/make.sh && check_terraform

.PHONY: check_docker
check_docker: ## Lint Dockerfiles
	@source test/make.sh && docker

.PHONY: check_base_files
check_base_files:
	@source test/make.sh && basefiles

.PHONY: check_shebangs
check_shebangs: ## Check that scripts have correct shebangs
	@source test/make.sh && check_bash

.PHONY: check_trailing_whitespace
check_trailing_whitespace:
	@source test/make.sh && check_trailing_whitespace

.PHONY: test_check_headers
test_check_headers:
	@echo "Testing the validity of the header check"
	@python test/test_verify_boilerplate.py

.PHONY: check_headers
check_headers: ## Check that source files have appropriate boilerplate
	@echo "Checking file headers"
	@python test/verify_boilerplate.py

.PHONY: generate_docs
generate_docs: ## Update README documentation for Terraform variables and outputs
	@source test/make.sh && generate_docs

# Versioning
.PHONY: version
version:
	@source helpers/version-repo.sh


.PHONY: test_integration
.ONESHELL:
test_integration:  ## Run a full integration test cycle
	@echo "Copying service-account-credentials.json to test dirs"
	cp service-account-credentials.json gcs-object/.
	cp service-account-credentials.json secret-infrastructure/.
	@echo Creating random string
	@echo "Running gcs-object integration test"
	cd gcs-object
	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
	cd ..
	@echo "Running secret-infrastructure integration test"
	cd secret-infrastructure
	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
	cd ..

	@echo "Running overall test-kitchen in docker"
	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
