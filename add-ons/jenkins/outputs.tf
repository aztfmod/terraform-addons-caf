#
# Output is a single map object with each server as a key
# and an object value of information. e.g.,
#
#  JenkinsServers = {
#    "JenkinsServerBasic" = {
#        "admin_SSH_Info" = {
#        "privateKeyFile" = "~/.ssh/id_rsa.pem"
#        "publicKeyFile" = "~/.ssh/id_rsa.pub"
#        }
#        "admin_id" = "adminuser"
#        "internal_ip" = "10.0.0.4"
#        "location" = "eastus"
#        "public_ip" = "13.92.99.196"
#        "resource_group" = "Jenkins-Normal"
#        "sku" = "Standard_F2"
#        "tags" = tomap({
#        "caf_level" = "level1"
#        "caf_state" = "100-V5.tfstate"
#        "caf_stateKey" = "jenkins"
#        "environment" = "prod02"
#        "lastUpdated" = "2021-05-13T21:31:38Z"
#        "serverRole" = "Jenkins"
#        })
#        "vm_resource_id" = "/subscriptions/5fa5c7a2-43af-43c8-a48a-dfa1e52352df/resourceGroups/Jenkins-SE/providers/Microsoft.Compute/virtualMachines/JenkinsServerBasic"
#    }
#    "JenkinsServerSpecial" = {
#        "admin_SSH_Info" = {
#        "privateKeyFile" = "~/.ssh/id_rsa.pem"
#        "publicKeyFile" = "~/.ssh/id_rsa.pub"
#        }
#        "admin_id" = "adifferentadminuser"
#        "internal_ip" = "10.0.0.4"
#        "location" = "eastus"
#        "public_ip" = "13.92.99.144"
#        "resource_group" = "Jenkins-Bigger"
#        "sku" = "Standard_F4"
#        "tags" = tomap({
#        "caf_level" = "level1"
#        "caf_state" = "100-V5.tfstate"
#        "caf_stateKey" = "jenkins"
#        "environment" = "prod02"
#        "lastUpdated" = "2021-05-13T21:31:38Z"
#        "serverRole" = "Jenkins"
#        })
#        "vm_resource_id" = "/subscriptions/5fa5c7a2-43af-43c8-a48a-dfa1e52352df/resourceGroups/Jenkins-SE-Bigger/providers/Microsoft.Compute/virtualMachines/JenkinsServerSpecial"
#    }
#  }
#

output "JenkinsServers" {
    value = module.jenkinsServer.*[0]
}
