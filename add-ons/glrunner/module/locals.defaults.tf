
locals {
  _default_admin = {
    username    = "gitlab"
    public_key  = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
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
    cert_path = "~/.data/ssl/server.crt"
  }
  _default_full_mode = false
}
