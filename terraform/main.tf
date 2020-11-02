provider "azurerm" {
  version = "=1.44.0"
}

#data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "tf_azure_guide" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  location            = "${azurerm_resource_group.tf_azure_guide.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.tf_azure_guide.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.tf_azure_guide.name}"
  address_prefix       = "${var.subnet_prefix}"
}

resource "azurerm_network_security_group" "tf-guide-sg" {
  name                = "${var.prefix}-sg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tf_azure_guide.name}"

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.source_network}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.source_network}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.source_network}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tf-guide-nic" {
  name                      = "${var.prefix}tf-guide-nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tf_azure_guide.name}"
  network_security_group_id = "${azurerm_network_security_group.tf-guide-sg.id}"

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.tf-guide-pip.id}"
  }
}

resource "azurerm_public_ip" "tf-guide-pip" {
  name                         = "${var.prefix}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tf_azure_guide.name}"
  allocation_method            = "Dynamic"
  domain_name_label            = "${var.hostname}"
}

resource "azurerm_virtual_machine" "site" {
  name                = "${var.hostname}-site"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tf_azure_guide.name}"
  vm_size             = "${var.vm_size}"

  network_interface_ids         = ["${azurerm_network_interface.tf-guide-nic.id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "${var.hostname}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "file" {
    source      = "files/setup.sh"
    destination = "/home/${var.admin_username}/setup.sh"

    connection {
      type     = "ssh"
      user     = "${var.admin_username}"
      password = "${var.admin_password}"
      host     = "${azurerm_public_ip.tf-guide-pip.fqdn}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.admin_username}/setup.sh",
      "sudo /home/${var.admin_username}/setup.sh",
    ]

    connection {
      type     = "ssh"
      user     = "${var.admin_username}"
      password = "${var.admin_password}"
      host     = "${azurerm_public_ip.tf-guide-pip.fqdn}"
    }
  }
}
