provider "aws" {
  region = "ap-south-1" 
}

resource "aws_vpc" "insurance_network" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Name = "insurance_network"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.insurance_network.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.insurance_network.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b" 
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "insurance-SG"
  description = "Allow HTTP, HTTPS, and SSH traffic"
  vpc_id      = aws_vpc.insurance_network.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "insurance-SG"
  }
backend "s3" {
    bucket         = "insurance_remote_backend"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
