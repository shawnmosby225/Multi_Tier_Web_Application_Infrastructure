// 1. ALB Security Group
resource "aws_security_group" "alb" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project_name}-ALB-SG"
  description = "Allows inbound HTTP/80 from the internet."

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// 2. EC2 App Server Security Group 
resource "aws_security_group" "app_server" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project_name}-AppServer-SG"
  description = "Allows inbound HTTP/80 from ALB and outbound to all."

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// 3. RDS Database Security Group
resource "aws_security_group" "rds" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project_name}-RDS-SG"
  description = "Allows inbound MySQL/3306 from App Servers."

  ingress {
    description     = "Allow MySQL from App Servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // Default egress
  }
}
