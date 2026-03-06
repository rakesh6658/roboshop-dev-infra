resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    tags = {
      Name ="${local.common_name}-catalogue"
    }
    subnet_id = split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]
  
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
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [ terraform_data.catalogue ]
}
resource "aws_ami_from_instance" "catalogue" {
  name               = "catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
}
resource "aws_lb_target_group" "catalogue" {
  name        = "${local.common_name}-catalogue"
  
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  deregistration_delay = 60
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-299"
    interval = 10
    port = 8080
    path = "/health"
    timeout = 5
    protocol = "HTTP"


  }
}
resource "aws_launch_template" "catalogue" {
  name = "${local.common_name}-catalogue"

  
  

   image_id = local.ami_id

  
  instance_type = "t3.micro"

  
 update_default_version = true

  
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.common_name}-catalogue"
    }
  }

tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "${local.common_name}-catalogue"
    }
  }
tags = merge(
  {
    Name = "${local.common_name}-catalogue"
  }
)
  
  
}
resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  

  launch_template {
    id = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
    
  }
  vpc_zone_identifier       = [local.private_subnet_ids]
target_group_arns = [aws_lb_target_group.catalogue.arn]
  
  dynamic "tag" {  # we will get the iterator with name as tag
    for_each = merge(
    
      {
        Name = "${local.common_name}-catalogue"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  
  timeouts {
    delete = "15m"
  }

 
}
resource "aws_autoscaling_policy" "catalogue" {
  name                   = "${local.common_name}-catalogue"
  autoscaling_group_name = aws_autoscaling_group.catalogue.arn
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = data.aws_ssm_parameter.listener_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values ="catalogue.backend-alb-${var.environment}.${var.domain_name}" 
  
    }
  }
}
resource "terraform_data" "delete_instance" {

  triggers_replace = [
    aws_instance.catalogue.id
  ]

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}