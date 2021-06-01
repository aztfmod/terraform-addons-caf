# Add-on to deploy Jenkins Server for Azure CAF landing zones

*Note:* these scenarios presume that you have already set up the CAF environment, including landing zones.

Supported scenario in this release:

1. Create the Jenkins Server as an Azure VM, based on a standard Linux image.

This add-on is responsible for provisioning one or more Jenkins servers, and installing the Jenkins software and prerequisites.  This advances the process to the next step being the manual "[unlocking](https://www.jenkins.io/doc/book/installing/linux/#unlocking-jenkins)" of the Jenkins server, via `http://localhost:8080` or using the publicIP of the server.

## Creating the Jenkins Server(s)

This example will create two Jenkins servers, each in their own resource group, virtual network and subnet.  Each server will have a public and private IP address.  One server is configured using the minimal settings.  The other demonstrates characteristics that can optionally be specified (e.g., VM SKU).  See the file `/tf/caf/caf_solution/add-ons/jenkins/example/jnks.tfvars` for the server and resource group names (and location) used for the example.

At completion, the outputs will include the configuration information for the provisioned VMs.  See the file `/tf/caf/caf_solution/add-ons/jenkins/outputs.tf` for an example output.

*Note:* Unless overridden (via input variables `adminUser`, `adminUserSSHPrivateKeyFile` and `adminUserSSHPublicKeyFile`), the add-on will provision an admin user named `adminuser` and the two files `~/.ssh/id_rsa.pem` and `~/.ssh/id_rsa.pub` are expected to exist during provisioning and will be used for ssh credentials for `adminuser`.  See the `jenkins.tf` file.

### Deploy via CAF rover

```bash
        export CAF_ENVIRONMENT="any-name-you-like-without-whitespace";
        rover \
           -tfstate myState.tfstate \
           -lz /tf/caf/add-ons/jenkins/ \
           -var-folder /tf/caf/add-ons/jenkins/example \
           -level level1 \
           -env "${CAF_ENVIRONMENT}" \
           -a apply
```

As can be observed in the add-on provisioning output, much of the information (e.g. level, environment, etc.) is also reflected in the set of Azure resource tags applied to the VM, VNET, etc.  Included in those tags is the last timestamp at which a resource was actually changed.

If you wish to test a deployment using the CAF Addons VSCode Dev Container, see the last section below for the steps.

## Defining the JenkinsServers block in a tfvars file

The example above (`./example/jnks.tfvars`) has examples of the minimal map required to define the server(s).

The outer block is named `jenkinsServers`, with each immediate key corresponding to the name of a VM to be defined as a Jenkins server.  Within the block the attributes are as follows.  Default values for optional attributes are defined in `tf_modules/jenkinsServer/optionalVars.tf`.   All attributes below are of type string.

Attribute | Optional? | Description
------ | ------- | ------------
`resource_group_name` | required | The Azure resource group in which to create the VM.  e.g., `"myRG"`
`location` | required | The Azure location where the VM should be created. e.g., `"eastus"`
`adminUser` | optional | The admin userid to configure for the VM. This user is used to perform the installation of the Jenkins software.  e.g., `"specialuser"`.
`adminUserSSHPrivateKeyFile` | optional | The path to the ssh private key file to use for `adminUser`.  e.g., `"~/.ssh/id_rsa"`
`adminUserSSHPublicKeyFile` | optional | The path to the ssh public key file to use for `adminUser`.  e.g., `"~/.ssh/id_rsa.pub"`
`vmSku` | optional | An Azure VM SKU to use in place of the default (`Standard_F2`).  e.g., `"Standard_F4"`

*Note:* To generate a new pair of `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` files, on Linux one could use:

```bash
      ssh-keygen -t rsa -m PEM -f ~/.ssh/id_rsa -b 4096 -N ""  # generates the id_rsa and id_rsa.pub files
```
Since `id_rsa` may be in use for other authentication purposes, or you simply want to use another pair, see the next section for some wrapper code to execute `ssh-keygen` in a more selective way. 

## Test Deployment using the VSCode Dev Container

To try deploying the example (`./add-ons/jenkins/example`) from scratch, the following steps within the VSCode Dev container for this project can be used.

*Note:* When doing cut-paste of commands from below, you may encounter the bash tab-expansion behavior - long delay followed by a very long command suggestion list - due to lines that happen to contain tabs.  To avoid this, you can use the sequence at the bottom of this document to create two functions - `tabson` and `tabsoff` which respectively enable and disable this behavior.  So, if you see the problem, preceding the paste with a `tabsoff` invocation will resolve the issue.

0. Sign into Azure via the CLI and set the default subscription
```bash
        az login
        # get the target subscription id.  e.g., 6aa5a7c2-411b-43d8-a48a-dfa1c52442df
        az account set --subscription 6aa5a7c2-411b-43d8-a48a-dfa1c52442df
```
1. In a VSCode terminal, connected to an instance of the dev container:
```bash
        cd /tf/caf
```
2. Set a shared CAF environment name
```bash
        export CAF_ENVIRONMENT="anyEnv123";
```
3. Add the CAF Landing Zones repo under the `./public` directory
```bash
        git clone https://github.com/Azure/caf-terraform-landingzones public
```
4. Install the CAF Landing zones.
```bash
        rover -lz /tf/caf/public/caf_launchpad -launchpad \
            -var-folder /tf/caf/public/caf_launchpad/scenario/100 \
            -parallelism 30 -level level0 -env ${CAF_ENVIRONMENT} -a apply
```
5. Create the required ssh keys for the admin user.  The example uses `id_rsa`, so a bit of care not to overwrite exisiting key files.  After the commands below, `id_rsa` and `id_rsa.pub` should exist in `~/.ssh`.  If you plan to modify the example to use a different keyset, just change `$_base` below.  If changing `$_base`, either use a full path or be mindful of where the first quote falls below to force bash to expand `~` correctly.
```bash 
        _base=~/'.ssh/id_rsa';
        if [[ ! -f ${_base}.pub || ! -f ${_base} ]]; then # generate a new key
           echo ssh-keygen -t rsa -m PEM -f "${_base}" -b 4096 -N ''
        else
            echo "One or both of the key files already exists... not regenerated"
            ls -la ${_base}*
        fi
```
6. Run the example:
```bash    
        rover -tfstate myState.tfstate -lz /tf/caf/add-ons/jenkins/ \
            -var-folder /tf/caf/add-ons/jenkins/example -level level1 \
            -env "${CAF_ENVIRONMENT}" -a apply
```
7. That sequence will have created the two VMs from the example.  To delete the resources from the example, simply rerun the same command but with destroy rather than apply.  e.g.,
```bash    
        rover -tfstate myState.tfstate -lz /tf/caf/add-ons/jenkins/ \
            -var-folder /tf/caf/add-ons/jenkins/example -level level1 \
            -env "${CAF_ENVIRONMENT}" -a destroy
```

## Addendum: Avoiding tab expansion issues when pasting commands

Bash's default configuration interprets the tab character as a request to supply a list of suggested commands.  Unfortunately, it is also triggered when pasting in command text that happens to contain tab characters.

To avoid this, define the following two bash functions.  Running `tabsoff` prior to pasting will avoid the problem.  `tabson` will restore the default bash behavior.   The code below is purposely not indented to allow for it's safe pasting in either mode.

```bash
#################################################
# Enable/Disable tab completion in bash.
# Useful when pasting code with leading tabs
#################################################
function tabsoff { # disable tab key mappings
bind -r '\C-i'
bind -r '\e\C-i'
}

function tabson { # enable tab key mappings
bind '"\C-i":complete'
bind '"\e\C-i":dynamic-complete-history'
}
```
