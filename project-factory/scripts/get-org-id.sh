#!/bin/bash

set -e

CONTROL_FLAG=-1
BASH_ORG_ID=""
PARAM_ID=$1
CREDENTIALS=$2

# If the folder_id == -1 then the org_id is ""
if [[ "$PARAM_ID" = "-1" ]];
then
  jq -n --arg org_id "" '{"org_id":$org_id}' && exit 0
fi

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS

while [[ $CONTROL_FLAG = -1 ]];
do
  # Retrieve the parent id of folder
  BASH_ORG_ID=$(gcloud alpha resource-manager folders describe $PARAM_ID --format="flattened[no-pad](parent)")
  # Save the current parent for next iteration, if needed
  PARAM_ID=$(echo $BASH_ORG_ID | cut -d'/' -f 2)
  # If parent is a organization, end while loop
  if [[ $BASH_ORG_ID = *"organizations"* ]];
  then
    CONTROL_FLAG=0
  fi
done

jq -n --arg org_id "$PARAM_ID" '{"org_id":$org_id}'
