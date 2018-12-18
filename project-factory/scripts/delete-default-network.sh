#!/bin/bash

PROJECT=$1
CREDENTIALS=$2

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS

echo "Deleting the default network in $PROJECT"

gcloud compute firewall-rules list --project=$PROJECT --format='value(name)' | while read line ;
do
    :
    RULE_NAME=$line
    gcloud compute firewall-rules delete $RULE_NAME --quiet --project=$PROJECT
done

gcloud compute networks delete default --quiet --project=$PROJECT
