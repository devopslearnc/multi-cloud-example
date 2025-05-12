resource "azurerm_resource_group" "example" {
  provider = azurerm.dev
  name     = "element-team-resources"
  location = "East US"
  tags     = local.common_tags
}

resource "azurerm_resource_group" "europe" {
  provider = azurerm.prod
  name     = "element-team-resources"
  location = "West Europe"
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "example" {
  provider = azurerm.dev
  name                = "virtual-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}

resource "azurerm_subnet" "example" {
  provider = azurerm.dev
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  provider = azurerm.dev
  name                = "engp-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  provider = azurerm.dev
  name                = "engp-sandbox"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/mural/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "aws_instance" "sandbox-est" {
  #provider = aws.us-east-1
  ami           = "ami-0f88e80871fd81e91" #i-079d7a6e04a0254d2
  instance_type = "t2.micro"

  tags = local.common_tags
}

resource "aws_instance" "sandbox-west" {
  provider = aws.us-west-1
  ami           = "ami-04fc83311a8d478df"
  instance_type = "t2.micro"

  tags = local.common_tags
}