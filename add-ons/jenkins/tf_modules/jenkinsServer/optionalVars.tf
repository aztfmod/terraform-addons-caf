
# Default values for select unspecified variable values.

locals {
  # In the absence of overriding values, use these for the admin user and ssh info for them.
  _defaultUserInfo = {
    userid = "adminuser"
    publicKey = "~/.ssh/id_rsa.pub"
    privateKey = "~/.ssh/id_rsa"
  }
  _defaultSKU = "Standard_F2"
}
