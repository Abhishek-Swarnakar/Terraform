
//VPC
variable "VPC_NAME" {
    description = "VPC"
    type = string
  
}
variable "VPC_CIDR" {
    description = "VPC-CIDR"
    type = string
}

//PUBLIC SUBNET

variable "PUBLIC_SUBNET_NAME" {
    description = "PUBLIC SUBNET NAME"
    type = list(string)
}
variable "PUBLIC_CIDR" {
    description = "PUBLIC SUBNET CIDR"
    type = list(string)
  
}
variable "PUBLIC_AZ" {
    description = "AZ for PUBLIC SUBNET"
    type = list(string)
  
}

//PRIVATE SUBNET

variable "PRIVATE_SUBNET_NAME" {
    description = "NAME"
    type = list(string)
  
}
variable "PRIVATE_SUBNET_CIDR" {
    description = "CIDR"
    type = list(string)
  
}
variable "PRIVATE_SUBNET_AZ" {
    description = "AZONE"
    type = list(string)
}

//PUBLIC ROUTE TABLE

variable "PUBLIC_ROUTE_TABLE_NAME" {
    description = "ROUTE NAME"
    type = list(string)
}
variable "PUBLIC_ROUTE_TABLE_CIDR" {
    description = "CIDR"
    type = string
  
}

//INTERNET GATEWAY

variable "INTERNET_GATEWAY" {
    description = "INTERNET GATEWAY"
    type = string
  
}

//PRIVATE ROUTE TABLE

variable "PRIVATE_ROUTE_TABLE_NAME" {
    description = "PRT NAME"
    type = list(string)
  
}
variable "PRIVATE_ROUTE_TABLE_CIDR" {
    description = "PRT_NAME"
    type = string
  
}

//NAT GATEWAY

variable "NAT_GATEWAY" {
    description = "NAT NAME"
    type = string
}

