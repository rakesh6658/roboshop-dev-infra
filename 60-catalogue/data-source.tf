data "aws_ami" "example" {
  owners           = ["973714476881"]
  most_recent = true
  #optional name 
  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
data "aws_ssm_parameter" "catalogue_sg_id" {
    name = "/${var.project}/${var.environment}/catalogue/sg_id"
  
}
data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.environment}/private_subnet_ids"
  
}
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
  
}
data "aws_ssm_parameter" "listener_arn" {
name = "/${var.project}/${var.environment}/listener_arn"
}
