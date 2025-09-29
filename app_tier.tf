resource "aws_launch_template" "app_lt" {
  provider      = aws.primary
  name          = "App-LT"
  image_id      = var.web_ami
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg_primary.id]
  }
}

resource "aws_autoscaling_group" "app_asg_az1" {
  provider            = aws.primary
  name                = "App-ASG-AZ1"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.private_app_az1.id]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  force_delete = true
}

resource "aws_autoscaling_group" "app_asg_az2" {
  provider            = aws.primary
  name                = "App-ASG-AZ2"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.private_app_az2.id]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  force_delete = true
}
