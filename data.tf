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
data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Gather default VPC's ID
data "aws_vpc" "default" {
  default = true
}