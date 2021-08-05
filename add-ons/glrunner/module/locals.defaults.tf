
locals {
  _default_admin = {
    username    = "gitlab"
    public_key  = "id_rsa.pub"
    private_key = "id_rsa"
  }
  _default_vm = {
    prefix  = "glrunner"
    size    = "Standard_D8s_v3"
    storage = "Premium_LRS"
  }
  _default_vm_image = {
    publisher = "Standard_D8s_v3"
    offer     = "Premium_LRS"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  _default_glserver = {
    cert = "server.crt"
    token = "token.txt"
  }
  _default_full_mode = false
  # _default_ci_workspace = "~"
}