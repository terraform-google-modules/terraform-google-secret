/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/**
* # terraform-gcp-get-gcs-object

* This is a module to fetch an object in a GCS bucket.

* ## Example usage

* See the living [barebones](examples/barebones-test-fixture) test fixture example for usage.

* ## Testing

* This module comes packaged with a test fixture and tests that can be run through
* Docker with the goal of running these through CI/CD. To get started testing locally:

* 1. Ensure a GCP credentials file sits at the repo root. You'll pass this filename in, and this credential file should align with the `PROJECT_NAME` you'll pass to Docker.
* 2. Install and run the [Docker CE daemon](https://www.docker.com/community-edition).
* 3. Build the Docer image and run all tests substituting the PROJECT_NAME for your sandbox:

*     ```bash
*     docker build . -t ubuntu-test-kitchen-terraform --build-arg PROJECT_NAME=simple-sample-project-cae8 --build-arg GOOGLE_APPLICATION_CREDENTIALS=service-account-credentials.json
*     ```

* 4. The above command runs tests end-to-end using `bundle exec kitchen test --destroy always` as included in the Dockerfile. If that fails, you'll need to iterate over test and fixture code. Login and re-converge with the following:

*     ```bash
*     # using your sandbox project name as PROJECT_NAME
*     docker run -it -v $PWD:/root/live_workspace -e "PROJECT_NAME=simple-sample-project-cae8" -w /root/live_workspace ubuntu-test-kitchen-terraform
*     # while logged into the Docker container, run through the create, converge, verify cycle keeping resources alive when finished. Run this as many times as needed:
*     tf_test
*     ```

* Your repo root is now mounted in the Docker container so you can edit any
* tests or fixture code on your workstation and rerun the `converge` command above
* to retry. When finished, spin down your GCP resources within the same container with:

* ```bash
* # also within the container
* tf_destroy
* ```

* If you've created several images, clean your workstaion using:

* ```bash
* docker system prune --volumes -f
* ```

* ## Doc generation

* Documentation should be modified within `main.tf` and generated using [terraform-docs](https://github.com/segmentio/terraform-docs).
* Generate them like so:

* ```bash
* go get github.com/segmentio/terraform-docs
* terraform-docs md ./ | cat -s | tail -r | tail -n +2 | tail -r > README.md
* ```
**/

resource "null_resource" "force-wait" {

}