resource "aws_instance" "server" {
  depends_on             = [aws_subnet.public_subnets, aws_internet_gateway.gw]
  ami                    = data.aws_ami.ubuntu.id
  count                  = length(var.availability_zones)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.allow.id]
  key_name               = data.aws_key_pair.key.key_name
  user_data              = <<-EOF
                              #!/bin/bash
                              sudo apt update
                              sudo apt install -y apache2
                              echo "<H1>Welcome to $(hostname -f) host :)</H1>" > /var/www/html/index.html
                              echo "<H2> I'm in subnet ${aws_subnet.public_subnets[count.index].tags.Name}}</H2>" >> /var/www/html/index.html
                              echo "<H2> Subnet's CIDR : ${var.cidr_blocks[count.index]}}</H2>" >> /var/www/html/index.html
                              echo "<H2>File created at : $(date)</H2>" >> /var/www/html/index.html
                              sudo systemctl start apache2
                              sudo systemctl enable apache2
                              EOF


  tags = {
    Servername = "Server-${count.index + 1}"
  }
}