terraform {
  backend "s3" {
    bucket = "project-s3-bucket-backend"
    key = "PROJECT/terraform.tfvars"
    region = "ap-south-1"


    
  }
}