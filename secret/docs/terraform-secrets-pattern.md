# GCP Terraform Secrets Pattern

## Overview

The following is pattern of sourcing secrets from Google
cloud storage buckets for use with Terraform. Below is an outline of the steps
you will need to follow to be able to remotely fetch those secrets and pass
them through to each Terraform resource that needs them.

## Update Project Factory

The permissions necessary to source secrets from their respective buckets come
bundled with Project Factory, but are only available at version ``v0.9.3`` or
higher. Because of this fact, you will need the bundled project factory

## Getting secrets into buckets

There is a subdirectory of keys/names of all secrets that are currently stored in all of the secrets
buckets. The structure underneath is implementation dependent.

### JSON formatting

If you need to get a secret stored into a GCS bucket then you’ll
need to provide the information on your secret in JSON format to someone with
access. Example below:

```
[{
    "app": "app1",
    "environments": ["dev", "staging"],
    "secrets": {
        "mysql_db_password": "ThisISmyPassword!",
        “another_password”: “SeeYouCanPassMoreThanOne”,
    }
}, {
    "app": "shared",
    "environments": ["dev", “int”, “qa”, “staging”],
    "secrets": {
        "datadog_api_key": "ThatLongKeyEveryoneAlreadyCopiedIntoTheirCode"
    }
}]
```

The JSON body is formatted as an array of hashes, with each hash element
representing one or more secrets. The first hash in the example above is
passing in two application-specific secrets for the applications (from the
``app`` key), and that secret will be available to all the non-prod environments
(as outlined in the ``environments`` key). The ``secrets`` key takes a hash containing
the secret name as a key, and the actual secret value as the value (and you can
see we are providing two secrets at once). The second example shows the format
for providing a secret that will be shared across ALL projects. The Datadog API
key is something all projects will need, so it makes sense to provide it to the
shared bucket.

### Getting the JSON-encoded secrets into their respective buckets
TBD

## Sourcing Secrets

The next step, once you have the required permissions for your project and have
ensured the secret is in its respective GCS bucket, is to declare a resource of
the terraform-gcp-secret module for every individual secret you will need to
source. 

For this example we’ll reference the Datadog API key and ensure that it is
available to every one of my components.  Consider the following bit of code
that’s needed to access the Datadog API key:

```
module "datadog_api_key" {
  source           = "https://github.com/terraform-google-modules/terraform-google-secret"
  application_name = "app1"
  env              = "int"
  shared           = "true"
  secret           = "datadog_api_key"
}
```

All the values are hardcoded so you can see them, but things like
application_name and env will have variables to populate them (usually
``local.app_name`` and ``local.env``). The most important value here is the ``shared``
attribute because it tells us whether this secret is going to be sourced from
the environment-specific bucket that EVERY application will share, or whether
it will be sourced from your application-specific bucket for that environment.
Because the Datadog API key is something everyone will need, we’ve set the
``shared`` attribute to the string of “true”. Finally the ``secret`` attribute is the
name of the secret that you will have provided above.

This module declaration will generate an output, called ``value``, that will
contain the value of your secret.  That output can be referenced like so:

```
locals {
  datadog_api_key     = "${module.datadog_api_key.value}"
}
```


## Testing with Terraform
TBD


## Getting Secrets from a Bucket Without Terraform

**NOTE: gsutil must have sufficient credentials **

```
ENV=”dev”
PROJECT_NAME=”sample-project” GCS_BUCKET=”"gs://${PROJECT_NAME}-${ENV}-secrets”
SECRETS_FILE=”super_secret_base64.txt”
DB_PWD=”$(gsutil cp ${GCS_BUCKET}/${SECRETS_FILE} -)”
```

Looking at the example above, ``ENV`` is self-explanatory, but ``PROJECT_NAME`` is
either the name of your project, or the string “shared” for shared secrets.
``SECRETS_FILE`` will be the name of your secret with the ``.txt`` extension added
(since that’s how secrets are actually stored in the buckets). The value of
your secret will be stored in the ``DB_PWD`` environment variable.

## Troubleshooting

Here are some of the common errors you may see when implementing this process:

```
Error: Error refreshing state: 1 error(s) occurred:

* module.datadog_api_key.module.gcs-object.data.http.remote_contents: 1 error(s) occurred:

* module.datadog_api_key.module.gcs-object.data.http.remote_contents: data.http.remote_contents: HTTP request error. Response code: 404
```

A response code of 404 means that a secret with the name you have provided
wasn’t found. That usually means that the secret isn’t in the bucket, but it
could ALSO mean that you set ``shared = "true"`` for a secret that might need to
come from an application-specific bucket (or vice versa) - so check your code.

This will also arise if you set ``shared = true`` (note the omission of the double
quotes) in your Terraform code. The string of true MUST be quoted - it cannot
be a boolean value.


```
Error: Error refreshing state: 1 error(s) occurred:

* module.datadog_api_key.module.gcs-object.data.http.remote_contents: 1 error(s) occurred:

* module.datadog_api_key.module.gcs-object.data.http.remote_contents: data.http.remote_contents: HTTP request error. Response code: 403
```

A response code of 403 means we don’t have permissions to access the storage
bucket.

