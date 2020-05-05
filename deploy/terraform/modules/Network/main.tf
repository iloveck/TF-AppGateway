#------ResourceGroup---------
resource "azurerm_resource_group" "this" {
  name     = "${var.compPrefix}-${var.projectName}-${var.componentName}-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
  }
}

resource "azure_virtual_network" "this" {
  name          = "rg-networkpoc
  address_space = ["10.1.2.0/24"]
  location      = "West US"

  subnet {
    name           = "subnet1"
    address_prefix = "10.1.2.0/25"
  }
}
