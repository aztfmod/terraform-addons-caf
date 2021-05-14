#
# Module to Provision a Jenkins server in it's own
# resource group and VNET.
#
module "jenkinsServer" {
    for_each = try(var.jenkinsServers, {})
    source = "./tf_modules/jenkinsServer"

    vmName = replace(each.key,"_","-")
    resourceGroupName = each.value.resource_group_name
    location = each.value.location
    resourcePrefix = replace(each.key,"_","-")
    tags = local.tags_computed

    # An admin user and ssh keys configured into the VM.
    # Required during provisioning.  If not specified in the
    # configuration in the tfvars file being provisioned, fall
    # back to the default values constructed in tf_modules/jenkinsServer/jenkins.tf.

    adminUser = lookup(each.value, "adminUser", null)
    adminUserSSHPrivateKeyFile = lookup(each.value, "adminUserSSHPrivateKeyFile", null)
    adminUserSSHPublicKeyFile =  lookup(each.value, "adminUserSSHPublicKeyFile", null)

    serverSku = lookup(each.value, "vmSku", null)
}
