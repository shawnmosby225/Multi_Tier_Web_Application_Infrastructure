
// Data source to find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

// 1. EC2 Launch Template (defines the configuration for new EC2 instances)
resource "aws_launch_template" "app_template" {
  name_prefix   = "${var.project_name}-LT"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro" // Choose a size based on need
  user_data     = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.app_server.id]
}

// 2. Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "${var.project_name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id 
}

// 3. ALB Target Group
resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

// 4. ALB Listener (Forwards all traffic from ALB to the Target Group)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

// 5. Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.project_name}-ASG"
  max_size             = 4
  min_size             = 2
  desired_capacity     = 2
  vpc_zone_identifier  = aws_subnet.app[*].id // ASG goes in Private Application Subnets

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type          = "ELB"
  health_check_grace_period  = 300

  tag {
    key                 = "Name"
    value               = "${var.project_name}-AppInstance"
    propagate_at_launch = true
  }
}
