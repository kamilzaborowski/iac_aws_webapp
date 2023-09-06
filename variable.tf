# Default region to use
variable "region" {
  default = "us-east-1"
}

# Database name
variable "db_name" {
  default = "db"
}

# Secret's name in AWS Secret Manager
variable "db_user" {
  default = "root"
}

variable "db_pass" {
  sensitive = true
}