resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-mongodb"
    }
    subnet_id = split(",",local.databasesubnet_id)
  
    vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
    
    
    
}
resource "terraform_data" "bootstrap" {
  triggers_replace = [
    aws_instance.mongodb.id
   
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
    
  }
  connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mongodb.private_ip
    }

  provisioner "remote-exec" {
    inline = [ 
    "sudo chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh"

     ]
  }
}