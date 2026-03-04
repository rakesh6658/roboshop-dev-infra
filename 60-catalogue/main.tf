resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-catalogue"
    }
    subnet_id = split(",",data.aws_ssm_parameter.private_subnet_id.value)[0]
  
    vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
    
    
    
  
}
resource "terraform_data" "catalogue" {
  triggers_replace = [aws_instance.catalogue.id]
  provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
    
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.catalogue.private_ip
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh catalogue dev"
     ]
    
  }
  
}
# resource "aws_ec2_instance_state" "catalogue" {
#   instance_id = aws_instance.catalogue.id
#   state       = "stopped"
#   depends_on = [ terraform_data.catalogue ]
# }
# resource "aws_ami_from_instance" "catalogue" {
#   name               = "catalogue-ami"
#   source_instance_id = aws_instance.catalogue.id
#   depends_on = [ aws_ec2_instance_state.catalogue ]
# }