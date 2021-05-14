#
# Example provisioning two Jenkins servers in the named Resource Groups
#
# JenkinsServerBasic will be a standard-size Jenkins server requiring only
# the two pieces of additional information.
#
# JenkinsServerSpecial includes optional overrides to userid, ssh configuration
# plus a larger VM SKU.  See README.md for more information.
#

jenkinsServers = {

  JenkinsServerBasic = {
    resource_group_name = "Jenkins-Normal"
    location = "eastus"
  },

  JenkinsServerSpecial = {
    resource_group_name = "Jenkins-Bigger"
    location = "eastus"

    # Optional overrides follow...

    # non-defaulted Admin user information
    adminUser = "adifferentadminuser"
    adminUserSSHPrivateKeyFile = "~/.ssh/id_rsa.pem"
    adminUserSSHPublicKeyFile =  "~/.ssh/id_rsa.pub"

    # non-defaulted VM SKU to use
    vmSku = "Standard_F4"
  }

}
