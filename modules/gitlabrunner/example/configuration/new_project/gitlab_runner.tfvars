gitlab_runners = {
  demo_runner  = {
    msi_name        = "msi-gitlab"
    msi_resource_group_name = "rg-gitlabsrv-daporo001"
    gitlab_server_resource_group = "rg-gitlabsrv-daporo001"
    gitlab_server_cert_path = "/mnt/c/dev/aztfmod/symphony/.data/ssl/server.crt"
    gitlab_server_internal_ip = "10.0.0.4"
    gitlab_server_fqdn = "daporogl.westus2.cloudapp.azure.com"
    gitlab_server_token = "6aByVYccdavafXZsez4Z"
    vnet_subnet = "gitlab-serverSubnet"
    vm_prefix = "gl-runner"
    vm_image_publisher = "Canonical"
    vm_image_offer = "UbuntuServer"
    vm_image_sku = "18.04-LTS"
    vm_image_version = "latest"
    vm_admin_username = "gitlab"
    vm_admin_public_key = "~/.ssh/id_rsa.pub"
    vm_admin_private_key = "~/.ssh/id_rsa"
    vm_size = "Standard_D8s_v3"
    vm_storage = "Premium_LRS"
    vm_count = 1
  }
}
