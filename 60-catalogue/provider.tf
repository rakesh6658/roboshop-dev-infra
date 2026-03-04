terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "remote-state-devops86s"
    key = "roboshop-dev-catalogue"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
    
  }
}
provider "aws" {
    region = "us-east-1"
  
}