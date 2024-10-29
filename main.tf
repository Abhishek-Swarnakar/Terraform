
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

variable "PRIVATE_ROUTE_TABLE_NAME" {
    description = "PRT NAME"
    type = list(string)
  
}
variable "PRIVATE_ROUTE_TABLE_CIDR" {
    description = "PRT_NAME"
    type = string
  
}
variable "NAT_GATEWAY" {
    description = "NAT NAME"
    type = string
}


// SG FOR ASG

variable "SECURITY_GROUP" {
    description = "SG NAME"
    type = string
  
}

//ASG TEMPLATE

variable "ASG_NAME" {
    description = "NAME"
    type = string
  
}
variable "EC2_IMAGE" {
    description = "IMAGE-ID"
    type = string
  
}
variable "EC2_TYPE" {
    description = "EC2_TYPE"
    type = string
  
}

//ASG

variable "NAME" {
    description = "ASG-NAME"
    type = string
  
}
variable "MIN_CAPACITY" {
    description = "CAPACITY"
    type = number
}
variable "MAX_CAPACITY" {
    description = "CAPACITY"
    type = number
  
}
variable "DESIRED_CAPACITY" {
    description = "CAPACITY"
    type = number
  
}
//ALB
variable "ALB_NAME" {
    description = "ALB_NAME"
    type = string
  
}




provider "aws" {
    region = "ap-south-1"
  
}




module "VPC" {
    source = "./modules/vpc"
    VPC_CIDR = var.VPC_CIDR
    VPC_NAME = var.VPC_NAME
    PUBLIC_SUBNET_NAME = var.PUBLIC_SUBNET_NAME
    PUBLIC_CIDR = var.PUBLIC_CIDR
    PUBLIC_AZ = var.PUBLIC_AZ
    PRIVATE_SUBNET_NAME = var.PRIVATE_SUBNET_NAME
    PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
    PRIVATE_SUBNET_AZ = var.PRIVATE_SUBNET_AZ 
    PUBLIC_ROUTE_TABLE_CIDR = var.PUBLIC_ROUTE_TABLE_CIDR
    PUBLIC_ROUTE_TABLE_NAME = var.PUBLIC_ROUTE_TABLE_NAME
    INTERNET_GATEWAY = var.INTERNET_GATEWAY
    PRIVATE_ROUTE_TABLE_NAME = var.PRIVATE_ROUTE_TABLE_NAME
    PRIVATE_ROUTE_TABLE_CIDR = var.PRIVATE_ROUTE_TABLE_CIDR
    NAT_GATEWAY = var.NAT_GATEWAY
}


module "ASG" {
    source = "./modules/ASG"
    vpc_id = module.VPC.vpc_id
    public_subnet_ids = module.VPC.public_subnet_ids
    private_subnet_ids = module.VPC.private_subnet_ids
    SECURITY_GROUP = var.SECURITY_GROUP
    ASG_NAME = var.ASG_NAME
    EC2_IMAGE = var.EC2_IMAGE
    EC2_TYPE = var.EC2_TYPE
    MIN_CAPACITY = var.MIN_CAPACITY
    MAX_CAPACITY = var.MAX_CAPACITY
    DESIRED_CAPACITY = var.DESIRED_CAPACITY
    NAME = var.NAME
    ALB_NAME = var.ALB_NAME

}

module "S3-backend" {
    source = "./modules/s3-backend"
  
}
