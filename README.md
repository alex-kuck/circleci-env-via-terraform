# circleci-env-via-terraform

In the wake of the [CircleCI security incident](https://circleci.com/blog/january-4-2023-security-alert/) in january
2023, it was strongly recommended to rotate all secrets stored in ENV variables. This
affected [project-specific secrets](https://circleci.com/docs/set-environment-variable/#set-an-environment-variable-in-a-project)
as well as secrets stored in [contexts](https://circleci.com/docs/contexts/), which can be shared across projects.

When using CircleCI for building multiple projects in an organization, the number of secrets can skyrocket quickly.
Although it is possible to change each secret manually, this is a very tedious and highly error-prone task. Not to
mention the necessity of revoking each of the possibly leaked secrets, possibly in various locations and systems.

Chances are you are already using Terraform to manage your infrastructure and also - at least a subset of - your secrets
used in your build pipelines. That's where
the [mrolla/circleci Terraform plugin](https://registry.terraform.io/providers/mrolla/circleci/latest/docs) comes in.
This allows you to populate your CircleCI ENV variables - both project- and organization-wide - automatically via
Terraform, as soon as they are updated.

This repository contains a minimal example highlighting how to automatically create or rotate a password of an Azure
Service Principal and setting it as a secret in CircleCI.

## Prerequisites

You need to create a [personal API token](https://circleci.com/docs/managing-api-tokens/#creating-a-personal-api-token)
for CircleCI in order to make changes via Terraform. You can set it as ENV variable `CIRCLECI_TOKEN` when executing
Terraform (check the plugin documentation for other approaches). If you want to run this example as-is, you also need an
Azure account.

**Note:** I did not check the pricing for any of the Azure resources used in this example, so be cautious and make sure
to not run up a bill by accident.

You can update the existing and add the missing variables in [dummy.tfvars](./dummy.tfvars) or provide the missing
variables when prompted. The following commands are defined in the [Makefile](./Makefile):

```shell
make dummy-plan # Make a plan of resources to update
make dummy-apply # Apply the previously created plan
make dummy-destroy # Destroy all defined resources
```
