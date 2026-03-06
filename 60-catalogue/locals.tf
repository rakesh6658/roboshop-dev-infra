locals {
  ami_id = data.aws_ami.example.id
  common_name = "${var.project}-${var.environment}"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = data.aws_ssm_parameter.private_subnet_ids.value

}