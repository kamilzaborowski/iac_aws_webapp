#Temporary EC2 instance to execute database creation in RDS instance, meant to be destroyed after all tasks of this resource
resource "aws_instance" "server" {
  depends_on    = [aws_db_instance.db_instance]
  ami           = data.aws_ami.webapp_ami.id
  instance_type = "t2.micro"
  #subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  user_data              = <<-EOF
                              #!/bin/bash
                              sudo apt update
                              sudo apt install git mysql_client -y
                              git clone https://github.com/kamilzaborowski/webapp
                              cd webapp/data
                              mysql --user ${var.db_user} --password ${var.db_pass} --host ${aws_db_instance.db_instance.address}
                              mysql \. init.sql
                              EOF
}