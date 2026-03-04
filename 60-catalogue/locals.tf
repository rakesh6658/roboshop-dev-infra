locals {
  ami_id = data.aws_ami.example.id
  common_name = "${var.project}-${var.environment}"

}