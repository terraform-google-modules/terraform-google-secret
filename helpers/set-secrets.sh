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
#description      :This script is used to set multiple secrets at once. Check README.md for full instructions.
#usage            :bash ./scripts/set-secrets.sh $CONFIG.json
#==============================================================================

# Parse params
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

JSON_FILE=$1

for app_object in $(< "${JSON_FILE}" jq -r '.[] | @base64'); do
    _jq() {
        echo "${app_object}" | base64 --decode | jq -r "${1}"
    }

    APP_NAME=$(_jq '.app')
    ENVS=$(_jq '.environments[]')
#    SECRETS=$(_jq '.secrets[]')

    for SECRET_NAME in $(_jq '.secrets | keys[]'); do
        SECRET_VALUE=$(_jq ".secrets.$SECRET_NAME")
        for ENV in $ENVS; do
            echo "Setting $SECRET_NAME for $APP_NAME in $ENV"
            "${BASH_SOURCE%/*}"/set-secret.sh "$APP_NAME" "$ENV" "$SECRET_NAME" "$SECRET_VALUE"
        done
    done
done
