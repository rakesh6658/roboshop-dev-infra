resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-mongodb"
    }
    subnet_id = local.databasesubnet_id
  
    vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
    
    
    
}
resource "terraform_data" "mongodb" {
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
    "sudo sh /tmp/bootstrap.sh mongodb"

     ]
  }
}
resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-redis"
    }
    subnet_id = local.databasesubnet_id
  
    vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
    
    
    
}
resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
   
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
    
  }
  connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.redis.private_ip
    }

  provisioner "remote-exec" {
    inline = [ 
    "sudo chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh redis"

     ]
  }
}
resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-rabbitmq"
    }
    subnet_id = local.databasesubnet_id
  
    vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
    
    
    
}
resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
   
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
    
  }
  connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.rabbitmq.private_ip
    }

  provisioner "remote-exec" {
    inline = [ 
    "sudo chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh rabbitmq"

     ]
  }
}
resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-mysql"
    }
    subnet_id = local.databasesubnet_id
  
    vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
    
    
    
}
resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
   
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
    
  }
  connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mysql.private_ip
    }

  provisioner "remote-exec" {
    inline = [ 
    "sudo chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh mysql"

     ]
  }
}
resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.mongodb.private_ip]
  depends_on = [ aws_instance.mongodb ]
}
resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.redis.private_ip]
  depends_on = [ aws_instance.redis ]
}
resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.rabbitmq.private_ip]
  depends_on = [ aws_instance.rabbitmq ]
}
resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.mysql.private_ip]
  depends_on = [ aws_instance.mysql ]
}


