#!/bin/bash

set -e

SUBNETS_LIST=$1
HOST_PROJECT=$2
CREDENTIALS=$3
RESULT="{}"

if [[ "$SUBNETS_LIST" == "-1" ]];
then
  echo "$RESULT" && exit 0
fi

# Construct subnet array
IFS=',' read -a SUBNETS_ARRAY <<< $SUBNETS_LIST

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS

#Perform region retrieval for each subnet
for SUBNET in "${SUBNETS_ARRAY[@]}"
do
  # We try to get the region
  REGION=$(export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS; gcloud compute networks subnets list --project $HOST_PROJECT --format="value[separator=' '](name,region)" | grep $SUBNET | cut -d' ' -f 2 | head -n 1)
  if [[ "$REGION" != "" ]];
  then
    RESULT=$(echo "$RESULT" | jq --arg subnet "$SUBNET" --arg region "$REGION" '(. |= .+ { ($subnet): $region } )')
  fi  
done

echo "$RESULT"