terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}


# EC2 instance
resource "aws_instance" "notely_ec2" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  key_name = var.ec2_key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = aws_subnet.public_subnet.id

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
              docker pull ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository}:latest
              docker run -d --restart unless-stopped -p 80:80 ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository}:latest
              EOF

  tags = {
    Name = "NotelyApp"
}
}