variable "projectName" {
    type = string
    default = "mglo"
}

variable "resourceGroupName" {
    type = string
}

variable "appInsightsKey" {
    type = string
}

variable "componentName" {
    type = string
}

variable "location" {
    type = string
    default = "westus2"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "VnetName" {
    type = string
    default = "az-np-westus2-usr-601-MGlo-network-vnet"
}

variable "VnetRGName" {
    type = string
    default = "az-np-westus2-usr-601-MGlo-network"
}

variable "SubnetName" {
    type = string
    default = "snet-FunctionApp1"
}

variable "FunctionAppPlanName" {
    type = string
    default = "MemberSignup"
}

variable "allowed_ip_addresses" {
  type = list(string)
  default = ["170.172.0.0/16", "170.167.0.0/16"]
}

variable "FunctionAppPlanRGName" {
    type = string
    default = "MemberSignup-PersonAPI"
}

variable "FunctionName" {
    type = string
}

variable "pairedRegionMap" {
    type = map
    default = {
        "westus2"  = "westus"
        "westus" = "westus2"
    }
}

variable "app_settings" {
   type = map
}
