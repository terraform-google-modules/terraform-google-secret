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
#description      :This script is used to generate a list of secrets.
#usage            :bash ./scripts/list-secrets.sh
#==============================================================================

# Parse params
die () {
    echo >&2 "$@"
    exit 1
}

SECRETS_PROJECT="secrets"
ROOT_FOLDER="./secrets/"

# Reset the secrets folder
rm -rf "$ROOT_FOLDER"

echo "Generating list of secrets in $ROOT_FOLDER"

BUCKETS=$(gsutil ls -p "$SECRETS_PROJECT" )
[[ $? -ne 0 ]] && die 'ERROR: Failed to get buckets list'

for BUCKET in $BUCKETS
do
    echo "Listing secrets stored in $BUCKET"

    # Parse bucket to find app and env
    [[ $BUCKET =~ gs://projects-(.*)-(.*)-secrets/ ]]
    APP=${BASH_REMATCH[1]}
    ENV=${BASH_REMATCH[2]}
    FILE_PATH="$ROOT_FOLDER/$APP/$ENV.txt"

    # Make folder to hold secrets
    mkdir -p "$(dirname "$FILE_PATH")"

    # Print contents of bucket
    BUCKET_ESCAPED=$(echo "$BUCKET" | sed -e 's/[]\/$*.^[]/\\&/g')
    bucket_ls=$(gsutil ls "$BUCKET") || die "ERROR: Failed to get objects list from $BUCKET" 
    echo "$bucket_ls" | sed "s/$BUCKET_ESCAPED\(.*\).txt/\1/" >> "$FILE_PATH"
done
