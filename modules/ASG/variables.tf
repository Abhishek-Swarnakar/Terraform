variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
    type = list(string)
  
}

variable "private_subnet_ids" {
    type = list(string)
  
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




