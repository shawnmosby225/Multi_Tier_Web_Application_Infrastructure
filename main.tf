terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

// Simple web server script to run on EC2 startup
data "template_file" "user_data" {
  template = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Welcome to the Multi-Tier App!</h1>" | sudo tee /var/www/html/index.html
  EOF
}
