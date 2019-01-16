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

# Docker build config variables
BUILD_TERRAFORM_VERSION ?= 0.11.10
BUILD_CLOUD_SDK_VERSION ?= 216.0.0
BUILD_PROVIDER_GOOGLE_VERSION ?= 1.17.1
BUILD_PROVIDER_GSUITE_VERSION ?= 0.1.8
DOCKER_IMAGE_TERRAFORM := cftk/terraform
DOCKER_TAG_TERRAFORM ?= ${BUILD_TERRAFORM_VERSION}_${BUILD_CLOUD_SDK_VERSION}_${BUILD_PROVIDER_GOOGLE_VERSION}_${BUILD_PROVIDER_GSUITE_VERSION}
BUILD_RUBY_VERSION := 2.5.3
DOCKER_IMAGE_KITCHEN_TERRAFORM := cftk/kitchen_terraform
DOCKER_TAG_KITCHEN_TERRAFORM ?= ${BUILD_TERRAFORM_VERSION}_${BUILD_CLOUD_SDK_VERSION}_${BUILD_PROVIDER_GOOGLE_VERSION}_${BUILD_PROVIDER_GSUITE_VERSION}

all: check_shell check_python check_golang check_terraform check_docker check_base_files test_check_headers check_headers check_trailing_whitespace generate_docs ## Run all linters and update documentation

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
check_terraform:
	@source ## Lint Terraform source files

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

# Integration tests
.PHONY: test_integration
test_integration: test_integration_gcs_object test_integration_secret_infrastructure ## Run integration tests
	bundle install
	bundle exec kitchen create
	# Yes, this is fugly. But we can fix this with terraform v0.12 when it is released
	-bundle exec kitchen converge
	bundle exec kitchen converge
	bundle exec kitchen verify
	bundle exec kitchen destroy

.PHONY: test_integration_gcs_object
test_integration_gcs_object: ## Run integration tests
	cd modules/gcs-object ; \
	bundle install ; \
	bundle exec kitchen create ; \
	bundle exec kitchen converge ; \
	bundle exec kitchen converge ; \
	bundle exec kitchen verify ; \
	bundle exec kitchen destroy ; \
	cd ../../

.PHONY: test_integration_secret_infrastructure
test_integration_secret_infrastructure: ## Run integration tests
	cd modules/secret-infrastructure ; \
	bundle install ; \
	bundle exec kitchen create ; \
	bundle exec kitchen converge ; \
	bundle exec kitchen converge ; \
	bundle exec kitchen verify ; \
	bundle exec kitchen destroy ; \
	cd ../../




.PHONY: generate_docs
generate_docs: ## Update README documentation for Terraform variables and outputs
	@source test/make.sh && generate_docs

.PHONY: release-new-version
release-new-version:
	@source helpers/release-new-version.sh

# Build Docker
.PHONY: docker_build_terraform
docker_build_terraform:
	cd ${WORKDIR} ;\
	docker build -f ${CURDIR}/build/docker/terraform/Dockerfile \
		--build-arg BUILD_TERRAFORM_VERSION=${BUILD_TERRAFORM_VERSION} \
		--build-arg BUILD_CLOUD_SDK_VERSION=${BUILD_CLOUD_SDK_VERSION} \
		--build-arg BUILD_PROVIDER_GOOGLE_VERSION=${BUILD_PROVIDER_GOOGLE_VERSION} \
		--build-arg BUILD_PROVIDER_GSUITE_VERSION=${BUILD_PROVIDER_GSUITE_VERSION} \
		--build-arg CREDENTIALS_FILE=${CREDENTIALS_FILE} \
		-t ${DOCKER_IMAGE_TERRAFORM}:${DOCKER_TAG_TERRAFORM} . ;\
	cd ${CURDIR}
.PHONY: docker_build_kitchen_terraform
docker_build_kitchen_terraform:
	cd ${WORKDIR} ;\
	docker build -f ${CURDIR}/build/docker/kitchen_terraform/Dockerfile \
		--build-arg BUILD_TERRAFORM_IMAGE="${DOCKER_IMAGE_TERRAFORM}:${DOCKER_TAG_TERRAFORM}" \
		--build-arg BUILD_RUBY_VERSION="${BUILD_RUBY_VERSION}" \
		--build-arg CREDENTIALS_FILE="${CREDENTIALS_FILE}" \
		-t ${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} . ;\
	cd ${CURDIR}

# Run docker
.PHONY: docker_run
docker_run:
	docker run --rm -it \
		-v $(CURDIR):/cftk/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash

.PHONY: docker_create
docker_create: docker_build_terraform docker_build_kitchen_terraform
	docker run --rm -it \
		-v $(CURDIR):/cftk/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen create"

.PHONY: docker_converge
docker_converge:
	docker run --rm -it \
		-v $(CURDIR):/cftk/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen converge || kitchen converge"

.PHONY: docker_verify
docker_verify:
	docker run --rm -it \
		-v $(CURDIR):/cftk/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen verify"

.PHONY: docker_destroy
docker_destroy:
	docker run --rm -it \
		-v $(CURDIR):/cftk/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen destroy"

.PHONY: test_integration_docker
test_integration_docker: WORKDIR = ${CURDIR}
test_integration_docker: docker_create docker_converge docker_verify docker_destroy test_integration_docker_gcs_object test_integration_docker_secret_infrastructure
	@echo "Running test-kitchen tests in docker"

.PHONY: test_integration_docker_gcs_object
test_integration_docker_gcs_object: WORKDIR = "./modules/gcs-object"
test_integration_docker_gcs_object: docker_create docker_converge docker_verify docker_destroy
	@echo "Running test-kitchen tests for gcs-object in docker"

.PHONY: test_integration_docker_secret_infrastructure
test_integration_docker_secret_infrastructure: WORKDIR = "./modules/secret-infrastructure"
test_integration_docker_secret_infrastructure: docker_create docker_converge docker_verify docker_destroy
	@echo "Running test-kitchen tests for secret-infrastructure in docker"


help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#.PHONY: test_integration check-env
#.ONESHELL:
#test_integration: check-env  ## Run a full integration test cycle
#	@echo "Copying service-account-credentials.json to test dirs"
#	cp service-account-credentials.json gcs-object/.
#	cp service-account-credentials.json secret-infrastructure/.
#	@echo Creating random string
#	@echo "Running gcs-object integration test"
#	cd gcs-object
#	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
#	cd ..
#	@echo "Running secret-infrastructure integration test"
#	cd secret-infrastructure
#	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
#	cd ..
#
#	@echo "Running overall test-kitchen in docker"
#	docker build . -f Dockerfile -t ubuntu-test-kitchen-terraform --build-arg RANDOM_SUFFIX=$(shell openssl rand -hex 5) --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
#
#help: ## Prints help for targets with comments
#	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
#
#check-env:
#ifndef PROJECT_NAME
#	$(error PROJECT_NAME is undefined)
#endif