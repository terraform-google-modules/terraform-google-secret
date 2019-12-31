# Create secret submodule

This submodule-helper isn't a part of the main `terraform-google-secret` module.
It could be used to create a multiply secrets using a json file as data-source, but also secrets could be created manual, by API call, by google SDK,
or using [provided helper scripts](../../helpers/manage-secrets).

The submodule use json input file, to store defined `secrets` on already created by [secret-infrastructure submodule](./secret-infrastructure) bucket in files `secret_name.txt` .
To store secrets is used bucket with name:
* `${var.project_id}-${var.application_name-${var.env}-secrets` for application-specific secrets
* `shared-${var.project_id}-${var.env}-secrets` for shared secrets.

## Usage
The input json file example:
The example of json submodule requires a json file  as input:
```json
[
  {
    "secret": "secret1",
    "secret_value": "foobar",
    "env": "qa",
    "application_name": "app1",
    "shared": false
  },
  {
    "secret": "secret2",
    "secret_value": "foobar_shared",
    "application_name": "any",
    "env": "dev",
    "shared": true
  }
]
```

[Module usage example](../../examples/create-multiply-secrets)
Basic usage of this submodule is as follows:

* for application-specific secrets:
```hcl
module "create_secrets" {
  source  = "terraform-google-modules/secret/google//modules/create-secrets"
  version = "1.0.0"

  secrets_file      = "${path.module}/secrets.json"
  project_id        = var.project_id
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| module\_depends\_on | The workaround for module dependencies. For example, could be used to wait before the bucket is created | list | `<list>` | no |
| project\_id | The id of the project secret buckets belong to | string | n/a | yes |
| secrets\_file | The path to `json` file with defined secrets. The json should be a list of objects with next keys: `secret_name`, `secret_value`, `application_name`, `env`, and `shared` | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
