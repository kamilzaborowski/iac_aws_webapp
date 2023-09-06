# Create SG for DB
resource "aws_security_group" "db_sg" {
  name = "db_sg"

  # Allow 3306 port inbound only (MySQL)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webapp_sg.id]
  }

  # Allow all ports outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}