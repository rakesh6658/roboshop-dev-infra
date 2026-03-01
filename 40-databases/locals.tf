locals {
  ami_id = data.aws_ami.main.id
  common_name = "${var.project}-${var.environment}"
  databasesubnet_id = split(",",data.aws_ssm_parameter.database_subnet_ids.value)[0]

}