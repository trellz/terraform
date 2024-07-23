# vm.tf

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface#example-usage
resource "azurerm_network_interface" "vm_network_interface" {
  name                = local.vnet_name
  location            = local.location
  resource_group_name = local.resource_group_name


  ip_configuration {
    name                          = "mka-vm_ip_configrationinternal"
    subnet_id                     = azurerm_subnet.mka-private.id
    private_ip_address_allocation = "Dynamic"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#example-usage

resource "azurerm_network_security_group" "vm_security_group" {
  name                = local.vm_security_group
  location            = local.location
  resource_group_name = local.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#example-usage
resource "azurerm_network_security_rule" "rdp" {
  name                        = "RDP"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.vm_security_group.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "HTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.vm_security_group.name
}

resource "azurerm_network_interface_security_group_association" "security_group_association" {
  network_interface_id      = azurerm_network_interface.vm_network_interface.id
  network_security_group_id = azurerm_network_security_group.vm_security_group.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#example-usage
resource "azurerm_windows_virtual_machine" "vm" {
  name                = local.vm_name
  location            = local.location
  resource_group_name = local.resource_group_name
  size                = "Standard_A1_v2"
  admin_username      = local.vm_admin_username
  admin_password      = local.vm_admin_password
  network_interface_ids = [
    azurerm_network_interface.vm_network_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
