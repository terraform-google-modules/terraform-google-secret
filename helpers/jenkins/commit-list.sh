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


# Get absolute path of secrets directory
secrets_dir="$(git rev-parse --show-toplevel)/secrets"

# Add changes to secrets/
git add "$secrets_dir" || exit $?

# Commit changes if any exist vs. HEAD
if [ -n "$(git diff-index HEAD)" ]; then
  git config --global user.name "Automation"
  git config --global user.email "test@example.com"
  git commit -m "[Jenkins] Update secrets list" -m "${BUILD_URL}" "$secrets_dir"
  git push -u origin master
else
  echo "No changes to commit."
  exit 0
fi

