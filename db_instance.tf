# Create MySQL 8.0.23 instance, with storage scaling up to 50 GB, using AWS Secret Manager and database name from variable
resource "aws_db_instance" "db_instance" {
  allocated_storage      = 1
  max_allocated_storage  = 50
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = data.aws_secretsmanager_secret_version.db_credentials.secret_string["username"]
  password               = data.aws_secretsmanager_secret_version.db_credentials.secret_string["password"]
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}