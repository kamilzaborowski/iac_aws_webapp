# ASG settings for web application servers, min 1 instance, max 5
resource "aws_autoscaling_group" "webapp_asg" {
  depends_on           = [aws_db_instance.db_instance, aws_instance.server]
  name                 = "webapp-asg"
  launch_configuration = aws_launch_configuration.webapp_lc.name
  vpc_zone_identifier  = [aws_security_group.webapp_sg.id, aws_security_group.db_sg.id]
  target_group_arns    = [aws_lb_target_group.webapp_tg.arn]
  min_size             = 1
  max_size             = 5
}

# ASG policy (scale in/out by 1 instance, wait 60 sec before action...)
resource "aws_autoscaling_policy" "webapp_asg_policy" {
  name                   = "webapp-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "TargetTrackingScaling"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name

  # ...when average CPU utilization will reach 70 %
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
# Launch configuration for every new instance in ASG
resource "aws_launch_configuration" "webapp_lc" {
  name          = "webapp_lc"
  image_id      = data.aws_ami.webapp_ami.id
  instance_type = "t2.micro"

  # Updates, download and install Apache, copy code from S3 bucket, start and enable
  user_data = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  sudo yum install -y httpd git
                  git clone https://github.com/kamilzaborowski/iac_aws_webapp
                  cp -R /iac_aws_webapp/ /var/www/html
                  rm -R iac_aws_webapp --force
                  sudo systemctl start httpd
                  sudo systemctl enable httpd
                  EOF
}