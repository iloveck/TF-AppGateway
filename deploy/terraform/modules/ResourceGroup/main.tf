#------ResourceGroup---------
resource "azurerm_resource_group" "this" {
  name     = "${var.compPrefix}-${var.projectName}-${var.componentName}-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
  }
}
