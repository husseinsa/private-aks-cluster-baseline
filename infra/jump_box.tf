resource "azurerm_public_ip" "jumpbox_ip" {
    name                        = "pip-${var.jump_box_name}"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.network_hub.name
    allocation_method           = "Static"
    sku                         = "Standard"
}

resource  "azurerm_network_interface" "jumpbox_nic" {
    name = "nic-${var.jump_box_name}"
    location =var.location
    resource_group_name         = azurerm_resource_group.network_hub.name


    ip_configuration {
      name =  "jumpbox_nic_config"
      subnet_id = azurerm_subnet.hub_azure_jumpbox_subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.jumpbox_ip.id
    }
}

resource "azurerm_network_security_group" "jumpbox_nsg" { 
    name                        = "nsg-${var.jump_box_name}"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.network_hub.name

    security_rule {
        name                            = "${var.jump_box_name}-ssh"
        priority                        = 100
        direction                       = "Inbound"
        access                          = "Allow"
        protocol                        = "Tcp"
        source_port_range               = "*"
        destination_port_range          = "22"
        source_address_prefix           = "*" 
        destination_address_prefix      = azurerm_subnet.hub_azure_jumpbox_subnet.address_prefixes[0]
    }
}

resource "azurerm_subnet_network_security_group_association" "jumpbox_nsg_association" { 
    subnet_id                   = azurerm_subnet.hub_azure_jumpbox_subnet.id
    network_security_group_id   = azurerm_network_security_group.jumpbox_nsg.id 
}

resource "azurerm_virtual_machine" "jumpbox_vm" {
    name                  = "vm-${var.jump_box_name}"
    location              =  var.location
    resource_group_name         = azurerm_resource_group.network_hub.name
    network_interface_ids = [azurerm_network_interface.jumpbox_nic.id]
    vm_size               = "Standard_DS1_v2"


    storage_image_reference {
       publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "myosdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "jumpboxvm"
        admin_username = "testadmin" //to be removed from here since this is sensitive information 
        admin_password = "Password1234!"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    tags = {
        environment = "dev"
    }

    delete_os_disk_on_termination = true //to force deleting the disk when running destroy. it can be mitigated using the azurerm_managed_disk resource 
                //separately and linking to that created instance in the storage_os_disk block. 
                //or You can try adding the following line to your code to delete the OS disk automatically when deleting the VM:

}

resource "azurerm_virtual_machine_extension" "custom_script_install_tools" {
    name = "vm-${var.jump_box_name}-customscript"
    virtual_machine_id = azurerm_virtual_machine.jumpbox_vm.id
    publisher = "Microsoft.Azure.Extensions"
    type = "CustomScript"
    type_handler_version = "2.0"

     protected_settings = <<PROT
    {
        "script": "${base64encode(file("./scripts/configure-jumpbox.sh"))}"
    }
    PROT  
}