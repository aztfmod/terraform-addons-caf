# GitHub CAF Module

> :warning: This solution, offered by the Open-Source community, will no longer receive contributions from Microsoft.

This submodule is part of [Azure Terraform SRE](https://github.com/aztfmod/terraform-azurerm-caf) landing zones for [GitHub on Terraform](https://github.com/githubhq/terraform-provider-github).

You can instantiate this submodule directly using the following parameters:

```terraform
module "github_projects" {
  source  = "aztfmod/caf/azurerm/modules/devops/providers/github"
  version = "3.5.0"
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
| integrations/github | >=4.9.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | The project configuration map | `map` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | The Project name. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example Usage (Guideline)

- Clone desired CAF launchpad and configuration repo, for demo purposes, you can use [CAF Launchpad repo](https://github.com/Azure/caf-terraform-landingzones)

```bash
git clone https://github.com/Azure/caf-terraform-landingzones public
```

- Export required environment variables

```bash
export ENVIRONMENT=<name_of_the_environment> # such as, demo, staging, production, etc.
export GITHUB_TOKEN=<pat_created_at_github.com_or_github_server> # created on github.com or github server
export GITHUB_OWNER=<username-or-organization>
# run the following command if you're using github server
export GITHUB_BASE_URL=<url_of_the_github_server>
```

- Provision Cloud Adoption Framework (CAF) Launchpad resources by executing the following script

```bash
rover -lz ./public/landingzones/caf_launchpad -launchpad -var-folder ./public/caf_launchpad/scenario/100 -parallelism 30 -level level0 -env ${ENVIRONMENT} -a apply
```

- Add GitHub project and couple of project variables into Level 1 (_Foundation Level_)

```bash
rover -lz ./examples/ -var-folder ./examples/github/new_project/ -level level1 -env ${ENVIRONMENT} -a apply
```

If you want to change the GitHub project configuration or project variables, see the example configuration in [examples/github/new_project/github_project.tfvars](./examples/github/new_project/github_project.tfvars) file;

```terraform
github_projects = {
  test_project = {
    name = "Test Project"
    description = "This is a test!"
    visibility  = "private"
  }

  demo_project  = {
    name        = "demo_project_20"
    description = "This is a demo!"
    visibility  = "private"
  }
}

```

> After it finish running (it may take couple of minutes) you'll see a project is created in the GitHub instance, with couple of project variables
