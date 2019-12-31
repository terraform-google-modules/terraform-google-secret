#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#description      :This script is used to clear a secrets. Check README.md for full instructions.
#usage            :bash ./scripts/clear-secret.sh $APPLICATION $ENVIRONMENT $SECRET_KEY
#==============================================================================

# Parse params
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 3 ] || die "3 arguments required, $# provided"

APPLICATION=$1
ENVIRONMENT=$2
SECRET_KEY=$3

# Build our bucket data
BUCKET_NAME="project-$APPLICATION-$ENVIRONMENT-secrets"
OBJECT_KEY="$SECRET_KEY.txt"

# Set the bucket object data
gsutil rm "gs://$BUCKET_NAME/$OBJECT_KEY"
