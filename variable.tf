# Default region to use
variable "region" {
  default = "us-east-1"
}

# Database name
variable "db_name" {
  default = "webapp_db"
}

# Secret's name in AWS Secret Manager
variable "secret_name" {
  default = "db_credentials"
}