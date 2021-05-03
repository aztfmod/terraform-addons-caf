# GitLab CAF Module

This submodule is part of [Cloud Adoption Framework](https://github.com/aztfmod/terraform-azurerm-caf) landing zones for [GitLab on Terraform](https://github.com/taiidani/terraform-provider-jenkins).

You can instantiate this submodule directly using the following parameters:

```terraform
module "jenkins_projects" {
  source  = "aztfmod/caf/azurerm/modules/devops/providers/jenkins"
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
| taiidani/jenkins | >=0.7.0-beta3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | The project configuration map | `map` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The Project ID. |
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
export JENKINS_URL=<JENKINS_URL> # URL of jenkins server
export JENKINS_USERNAME=<JENKINS_USERNAME> # Username created on jenkins server
export JENKINS_PASSWORD=<JENKINS_PASSWORD> # password created on jenkins server
```

- Provision Cloud Adoption Framework (CAF) Launchpad resources by executing the following script

```bash
rover -lz /tf/caf/public/caf_launchpad -launchpad -var-folder /tf/caf/public/caf_launchpad/scenario/100 -parallelism 30 -level level0 -env ${ENVIRONMENT} -a apply
```

- Add Jenkins project and couple of project variables into Level 1 (_Foundation Level_)

```bash
rover -lz /tf/caf/examples/ -var-folder /tf/caf/examples/jenkins/new_project/ -level level1 -env ${ENVIRONMENT} -a apply
```

If you want to change the Jenkins project configuration or project variables, see the example configuration in [examples/jenkins/new_project/jenkins_project.tfvars](./examples/jenkins/new_project/jenkins_project.tfvars) file;

```terraform
jenkins_projects = {
  test_project  = {
    name        = "test_job"
    description = "test job description"
    visibility  = "private"

    variables = {
      var1 = {
        value = "testvalue1"
        protected = true
        masked = false
      }
      var2 = {
        value = "testvalue2"
        protected = false
        masked = true
      }
      var3 = {
        value = "testvalue3"
        protected = true
      }
      var4 = {
        value = "testvalue4"
        masked = true
      }
    }
  }
}
```

> After it finish running (it may take couple of minutes) you'll see a job is created in the Jenkins instance, with couple of project variables
