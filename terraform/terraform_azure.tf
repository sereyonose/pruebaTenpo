provider "azurerm" {
  version = "=2.2"
  features {}
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "myterraformpublicipapp" {
    name                         = "myPublicIPApp"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"
    domain_name_label            = "myterraformpublicipapptenpoapi"
       
    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_public_ip" "myterraformpublicipdb" {
    name                         = "myPublicIPDb"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"
    domain_name_label            = "myterraformpublicipdbtenpodb"
  
    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "POSTGRESS"
        priority                   = 1021
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = 5432
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "3000"
        priority                   = 1031
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = 3000
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface" "myterraformnicapp" {
    name                        = "myNICApp"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "myNicConfigurationApp"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicipapp.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "networkassocciationapp" {
    network_interface_id      = azurerm_network_interface.myterraformnicapp.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


resource "azurerm_network_interface" "myterraformnicdb" {
    name                        = "myNICDB"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "myNicConfigurationDb"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicipdb.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface_security_group_association" "networkassociationdb" {
    network_interface_id      = azurerm_network_interface.myterraformnicdb.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.myterraformgroup.name
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    location                    = "eastus"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}


resource "azurerm_linux_virtual_machine" "myterraforVmApp" {
    name                  = "vmApp"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnicapp.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myVmAppDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "vmApp"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = file("~/.ssh/id_rsa.pub")
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo Environment"
    }

    provisioner "remote-exec" {
        connection {
            type     = "ssh"
            host     = "myterraformpublicipapptenpoapi.eastus.cloudapp.azure.com"
            user     = "azureuser"
            password = ""
        }

        inline = [
            "echo 'JWTPASSWORD=${var.api_jwtpassword}' >> ~/.env ",
            "echo 'DB_USER=${var.api_db_user}' >> ~/.env ",
            "echo 'DB_PASSWORD=${var.api_db_password}' >> ~/.env ",
            "echo 'DB_HOST=${var.api_db_host}' >> ~/.env ",
            "echo 'DB_DATABASE=${var.api_db_database}' >> ~/.env ",
            "echo 'DB_PORT=${var.api_db_port}' >> ~/.env ",
            "wget https://raw.githubusercontent.com/csereya/pruebaTenpo/main/scripts/api.sh",
            "chmod +x api.sh",
            "./api.sh"
        ]
    }

}

resource "azurerm_linux_virtual_machine" "myterraforVmDB" {
    name                  = "vmDB"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnicdb.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myVmDbDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "vmDB"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = file("~/.ssh/id_rsa.pub")
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo Environment"
    }

    provisioner "remote-exec" {
        connection {
            type     = "ssh"
            host     = "myterraformpublicipdbtenpodb.eastus.cloudapp.azure.com"
            user     = "azureuser"
            password = ""
        }

        inline = [
            "echo '${var.api_db_password}' >> ~/.env ",
            "wget https://raw.githubusercontent.com/csereya/pruebaTenpo/main/scripts/db.sh",
            "chmod +x db.sh",
            "./db.sh"
        ]
    }
}
