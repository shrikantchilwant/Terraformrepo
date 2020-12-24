#########################################################################
# Variables
#########################################################################

variable "subscription_id" {}
variable "client_id"{}
variable "client_secret"{}
variable "tenant_id"{}
variable "location" {}



#########################################################################
# Providers
#########################################################################

provider "azurerm" {

subscription_id = var.subscription_id
client_id       = var.client_id
client_secret   = var.client_secret
tenant_id       = var.tenant_id

features {}

}

#########################################################################
# Rsources
#########################################################################

# Create a resource group
resource "azurerm_resource_group" "dev_rg" {
  name     = "devlopment_rg"
  location = var.location
}

resource "azurerm_resource_group" "uat_rg" {
  name     = "uat_rg"
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "app-vnet" {
  name                = "application-network"
  resource_group_name = azurerm_resource_group.dev_rg.name
  location            = azurerm_resource_group.dev_rg.location
  address_space       = ["10.0.0.0/16"]


# Subnets
subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_network_security_group" "app_security_group" {
  name                = "applicationSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name
}

  resource "azurerm_network_security_rule" "SG01" {
  name                        = "RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dev_rg.name
  network_security_group_name = azurerm_network_security_group.app_security_group.name
}