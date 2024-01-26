# Azure DevOps

> :warning: This solution, offered by the Open-Source community, will no longer receive contributions from Microsoft.

This submodule is part of [Azure Terraform SRE](https://github.com/aztfmod/terraform-azurerm-caf) landing zones for [Azure](https://github.com/terraform-providers/terraform-provider-azurerm).

You can instantiate this submodule directly using the following parameters:

```terraform
module "azure_devops_projects" {
  source  = "aztfmod/caf/azurerm//modules/devops/providers/azure-devops"
  version = "5.1.3"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| microsoft/azuredevops | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_config | Client configuration object (see module README.md). | `any` | n/a | yes |
| global\_settings | Global settings object (see module README.md) | `any` | n/a | yes |
| project | The project configuration map | `map` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The Project ID. |
| name | The Project name. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example Usage (Guideline)

- Clone desired CAF lanchpad and configuration repo, for demo purposes, you can use [CAF Launchpad repo](https://github.com/Azure/caf-terraform-landingzones)

```bash
git clone https://github.com/Azure/caf-terraform-landingzones public
```

- Export required environment variables

```bash
export ENVIRONMENT=<name_of_the_environment> # such as, demo, staging, production, etc.

# To create information for following values, see documentation ; https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
export ARM_CLIENT_ID=<azure_client_id>
export ARM_CLIENT_SECRET=<azure_client_secret>
export ARM_SUBSCRIPTION_ID=<azure_subscription_id>
export ARM_TENANT_ID=<azure_tenant_id>
```

- Provision Cloud Adoption Framework (CAF) Launchpad resources by executing the following script

```bash
rover -lz ./public/landingzones/caf_launchpad -launchpad -var-folder ./public/caf_launchpad/scenario/100 -parallelism 30 -level level0 -env ${ENVIRONMENT} -a apply
```

- Add Azure DevOps project into Level 1 (_Foundation Level_)

```bash
rover -lz ./examples/ -var-folder ./examples/azure-devops/new_project -level level1 -env ${ENVIRONMENT} -a apply
```

If you want to change the Azure DevOps project configuration, see the example configuration in [examples/azure-devops/new_project/ado_project.tfvars](./examples/azure-devops/new_project/ado_project.tfvars) file;

```terraform
azure_devops_projects = {
  test_project = {
    name = "Test Project"
  }
}
```

> After it finish running (it may take couple of minutes) you'll see a project is created in the Azure DevOps instance
