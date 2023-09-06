# ASG settings for web application servers
resource "aws_autoscaling_group" "webapp_asg" {
  name                 = "webapp_asg"
  launch_configuration = aws_launch_configuration.webapp_lc.name
  vpc_zone_identifier  = [data.aws_subnet_ids.default.ids[0]]
  target_group_arns    = [aws_lb_target_group.webapp_tg.arn]

  dynamic_scaling_policy_configuration {
    target_value           = 500 # MB of RAM usage per instance
    predefined_metric_type = PredefinedMetricSpecification.MemoryUtilization #pointing target_value to memory

    # When threshold is exceeded, scale out by 1 instance and wait 60 seconds before the action (cooldown)
    # Similar for scaling in, when threshold is satisfying, terminating 1 instance after 60 sec of cooldown
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    scaling_adjustment = 1

    # Min and max capacity
    min_capacity = 1
    max_capacity = 5
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
                  sudo yum install -y httpd
                  aws s3 cp s3://kamil-zaborowski-s3/webapp /var/www/html
                  sudo systemctl start httpd
                  sudo systemctl enable httpd
                  echo "<h1>Welcome to the web application</h1>" > /var/www/html/index.html
                  echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
                  echo "<p>Instance Type: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>" >> /var/www/html/index.html
                  echo "<p>Database Name: ${var.db_name}</p>" >> /var/www/html/index.html
                  echo "<p>Database Endpoint: ${aws_db_instance.db_instance.endpoint}</p>" >> /var/www/html/index.html
                  EOF
}