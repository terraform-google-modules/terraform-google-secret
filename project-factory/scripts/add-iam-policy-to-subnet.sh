#!/bin/bash

# Subnet to add policy
SUBNETS=$1

# Host project where subnet is
HOST_PROJECT=$2

# Region where subnet is
REGION=$3

# Service Account to grant role
SERVICE_ACCOUNT=$4

# Group to grant role
GROUP=$5

CREDENTIALS=$6

# Create json temp file
FILE_NAME="temp_$RANDOM.json"
touch $FILE_NAME
chown $(whoami) $FILE_NAME
cat <<EOF > $FILE_NAME
{
  "bindings": [
    {
      "members": [
        "serviceAccount:$SERVICE_ACCOUNT",
        "group:$GROUP"
      ],
      "role": "roles/compute.networkUser"
    }
  ],
}
EOF

# Construct subnet array
IFS=',' read -a SUBNETS_ARRAY <<< $SUBNETS

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS

#Perform command for each subnet
for SUBNET in "${SUBNETS_ARRAY[@]}"
do
  gcloud beta compute networks subnets set-iam-policy $SUBNET $FILE_NAME --region $REGION --project $HOST_PROJECT --quiet
done

rm -f $FILE_NAME
