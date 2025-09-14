terraform {
  required_version = ">= 1.0"
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

# EC2インスタンス（シンプル構成）
resource "aws_instance" "main" {
  ami                    = "ami-000322c84e9ff1be2"  # Amazon Linux 2 (x86_64)
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${var.project_name}-server"
  }
}

# キーペア
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-keypair"
  public_key = file("${path.module}/mysfa-dev-keypair.pub")
}

# セキュリティグループ（シンプル）
resource "aws_security_group" "main" {
  name_prefix = "${var.project_name}-"
  description = "Security group for MySFA application"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # アプリケーション
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

