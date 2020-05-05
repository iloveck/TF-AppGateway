variable "VnetName" {
    type = string
#    default = "az-np-westus2-usr-601-MGlo-network-vnet"
}

variable "VnetRGName" {
    type = string
#    default = "az-np-westus2-usr-601-MGlo-network"
}

variable "SubnetName" {
    type = string
#    default = "snet-applicationgateway"
}

variable "location" {
    type = string
    default = "westus2"
}

variable "environment" {
    type = string
#    default = "dev"
}

variable "resourceGroupName" {
    type = string
}

variable "AppGatewayWAFPolicy" {
    type = string
#    default = "mglo-app-gateway-waf-policy"
}

variable "AppGatewayName" {
    type = string
#    default = "mglo-AppGateway"
}

variable "FrongEndIPAddr" {
    type = string
}

variable "ssl_certificate_name" {
    type = string
}

/*variable "appgw_fqdns" {
    type = list(string)
}*/
