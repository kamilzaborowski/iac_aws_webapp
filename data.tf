# Use the latest Amazon Linux 2 AMI
data "aws_ami" "webapp_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Gather default subnet IDs
data "aws_subnets" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Gather default VPC's ID
data "aws_vpc" "default" {
  default = true
}

# Data to point downloading correct secrets by choosing the secret name in AWS Secret Manager 
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.secret_name
}

# SSH key to access instance
data "aws_key_pair" "key" {
  key_name = "terraform"
}