# Use version 5.15.x of AWS API
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.15.0"
    }
  }
}

# Use region from variable, take credentials and config from file created with AWS CLI
provider "aws" {
  region                   = var.region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  default_tags {
    tags = {
      Coordinator = "Kamil Zaborowski"
      Project     = "IaC-AWS-WebApp"
    }
  }
}