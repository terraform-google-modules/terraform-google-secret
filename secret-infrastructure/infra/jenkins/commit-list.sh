#!/bin/bash

# Get absolute path of secrets directory
secrets_dir="$(git rev-parse --show-toplevel)/secrets"

# Add changes to secrets/
git add $secrets_dir || exit $?

# Commit changes if any exist vs. HEAD
if [ ! -z "$(git diff-index HEAD)" ]; then
  git config --global user.name "Automation"
  git config --global user.email "test@example.com"
  git commit -m "[Jenkins] Update secrets list" -m "${BUILD_URL}" $secrets_dir
  git push -u origin master
else
  echo "No changes to commit."
  exit 0
fi

