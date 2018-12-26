## Setting secrets concepts
In general, this repo is built to run in CI/CD. It's not usually appropriate to have the setting of secrets performed in that manner.

This directory has a basic concept for setting secrets. The code is here doesn't run as-is (bucket names will need to be adjusted, etc), but is provided as a way to think about setting secrets.
Conceptually, secrets are set manually by a team authorized to perfom this work. 

The team would use the scripts/set-secrets.sh script to set the secret (see [below](#setting-secrets)). 

In this scenario, the GCS buckets are the source of truth. It might be necessary to have a list of the secrets stored in source control for auditability. See [jenkins](#jenkins-automation). 

### File structure
The directory has the following folders and files:

- scripts/ - Contains the helper scripts for setting/clearing scripts
- jenkins/ - Contains an example Jenkins Groovy for capturing defined secret names in source 


### Setting Secrets
Application secrets are set using the following inputs:

- APPLICATION_NAME (ex. `app1`)
- ENVIRONMENT (ex. `dev`)
- SECRET_NAME is the key the secret will be referenced by (ex. `my-secret`)
- SECRET_VALUE is the value of the secret (ex. `my-secret-value`)

The script is executed like this:

```
./scripts/set-secret.sh APPLICATION_NAME ENVIRONMENT SECRET_NAME SECRET_VALUE
```

For example:
```
./scripts/set-secret.sh app1 dev my-secret my-secret-name
```

Shared secrets which are referenced by multiple applications are set the same way, simply using `shared` as the application name. For example:

```
./scripts/set-secret.sh shared dev datadog-key the-datadog-secret-key
```

Multiple secrets can be set at once using the [`set-secrets.sh`](./scripts/set-secrets.sh) script, which accepts a JSON file (syntax example in [`secrets.json`](./examples/secrets.json)).

```
./scripts/set-secrets.sh examples/secrets.json
```

### Clearing Secrets
Secrets which are no longer needed should be cleared using the secret clearing sript:

```
./scripts/clear-secret.sh APPLICATION_NAME ENVIRONMENT SECRET_NAME
```

### Listing Secrets
A listing of all secrets managed by this module is included in the [`secrets`](./secrets) folder. This listing is generated automatically with this command:

```
./scripts/list-secrets.sh
```

### Jenkins automation

./jenkins is a pipeline with the goal of having an up to date capture of the defined secrets in source. The groovy script is triggered in Jenkins (via cron).
This script calls list-secrets.sh, which fetches all the defined secrets. It then calls commit-list.sh to commit them to source control. All three of these files will need modification to work correctly in your environments. 

```
./jenkins/default-update-secrets-list.groovy
```

```
./jenkins/commit-list.sh
```