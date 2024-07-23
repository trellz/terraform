# locals.tf

locals {
  resource_group_name = "mka-example-resources"
  location            = "East US"

  vnet_name           = "mka-example-virtual-network"
  public_subnet_name  = "public"
  private_subnet_name = "private"

  vm_network_interface_name = "example-network-interface"
  vm_security_group         = "mka-example-security-group"

  vm_name           = "mka-example-vm"
  vm_admin_username = "adminuser"
  vm_admin_password = "P@$$w0rd1234!"


  bastion_public_ip_name = "example-bastion-public-ip"
  bastion_host_name      = "example-bastion"
}
