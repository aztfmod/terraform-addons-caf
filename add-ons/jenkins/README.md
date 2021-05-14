# Add-on to deploy Jenkins Server for Azure CAF landing zones

*Note:* these scenarios presume that you have already set up the CAF environment, including landing zones.

Supported scenario in this release:

1. Create the Jenkins Server as an Azure VM, based on a standard Linux image.

This add-on is responsible for provisioning one or more Jenkins servers, and installing the Jenkins software and prerequisites.  This advances the process to the next step being the manual "[unlocking](https://www.jenkins.io/doc/book/installing/linux/)" of the Jenkins server, via `http://localhost:8080` or using the publicIP of the server.

## Creating the Jenkins Server(s)

This example will create two Jenkins servers, each in their own resource group, virtual network and subnet.  Each server will have a public and private IP address.  One server is configured using the minimal settings.  The other demonstrates characteristics that can optionally be specified (e.g., VM SKU).  See the file `/tf/caf/caf_solution/add-ons/jenkins/example/jnks.tfvars` for the server and resource group names (and location) used for the example.

At completion, the outputs will include the configuration information for the provisioned VMs.  See the file `/tf/caf/caf_solution/add-ons/jenkins/outputs.tf` for an example output.

*Note:* Unless overridden (via input variables `adminUser`, `adminUserSSHPrivateKeyFile` and `adminUserSSHPublicKeyFile`), the add-on will provision an admin user named `adminuser` and the two files `~/.ssh/id_rsa.pem` and `~/.ssh/id_rsa.pub` are expected to exist during provisioning and will be used for ssh credentials for `adminuser`.  See the `jenkins.tf` file.

### Deploy via CAF rover

```bash
export CAF-ENVIRONMENT="any-name-you-like-without-whitespace";
rover \
    -tfstate myState.tfstate \
    -lz /tf/caf/caf_solution/add-ons/jenkins/ \
    -var-folder /tf/caf/caf_solution/add-ons/jenkins/example \
    -level level1 \
    -env "${CAF-ENVIRONMENT}" \
    -a apply
```

As can be observed in the add-on provisioning output, much of the information (e.g. level, environment, etc.) is also reflected in the set of Azure resource tags applied to the VM, VNET, etc.  Included in those tags is the last timestamp at which a resource was actually changed.

## Defining the JenkinsServers block in a tfvars file

The example above (jnks.tfvars) has examples of the minimal map required to define the server(s).

The outer block is named `jenkinsServers`, with each immediate key corresponding to the name of a VM to be defined as a Jenkins server.  Within the block the attributes are as follows.  Default values for optional attributes are defined in `tf_modules/jenkinsServer/optionalVars.tf`.   All attributes below are of type string.

Attribute | Optional? | Description
------ | ------- | ------------
`resource_group_name` | required | The Azure resource group in which to create the VM.  e.g., `"myRG"`
`location` | required | The Azure location where the VM should be created. e.g., `"eastus"`
`adminUser` | optional | The admin userid to configure for the VM. This user is used to perform the installation of the Jenkins software.  e.g., `"specialuser"`.
`adminUserSSHPrivateKeyFile` | optional | The path to the ssh private key file to use for `adminUser`.  e.g., `"~/.ssh/id_rsa.pem"`
`adminUserSSHPublicKeyFile` | optional | The path to the ssh public key file to use for `adminUser`.  e.g., `"~/.ssh/id_rsa.pub"`
`vmSku` | optional | An Azure VM SKU to use in place of the default (`Standard_F2`).  e.g., `"Standard_F4"`

*Note:* To generate a new pair of `~/.ssh/id_rsa.{pub,pem}` files, on Linux use:

```bash
ssh-keygen -t rsa -m PEM -f ~/.ssh/id_rsa -b 4096 -N ""  # generates the id_rsa and id_rsa.pub files
mv ~/.ssh/id_rsa ~/.ssh/id_rsa.pem  # adjust the naming.
```
