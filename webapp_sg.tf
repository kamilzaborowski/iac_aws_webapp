# Create SG for web app, used for ASG
resource "aws_security_group" "webapp_sg" {
  name = "webapp_sg"

  # # Allow 80 port inbound only (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all ports outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}