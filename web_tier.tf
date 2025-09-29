resource "aws_launch_template" "web_lt" {
  provider      = aws.primary
  name          = "Web-LT"
  image_id      = var.web_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg_primary.id]
}

resource "aws_autoscaling_group" "web_asg" {
  provider            = aws.primary
  name                = "Web-ASG"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [
    aws_subnet.public_web_az1.id,
    aws_subnet.public_web_az2.id
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "Web-ASG-Instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "web_alb" {
  provider           = aws.primary
  name               = "Web-ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.public_web_az1.id,
    aws_subnet.public_web_az2.id
  ]
}

resource "aws_lb_target_group" "web_tg" {
  provider = aws.primary
  name     = "Web-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_primary.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "web_listener" {
  provider          = aws.primary
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
