# Target group to point web app for ALB
resource "aws_lb_target_group" "webapp_tg" {
  name     = "webapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  # Health check: every 10 sec, 5 timeouts, terminating after 3 tries without response, checking root path
  health_check {
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    path                = "/"
  }
}

# Choose load balancer type application (ALB)
resource "aws_lb" "webapp_lb" {
  name               = "webapp_lb"
  load_balancer_type = "application"

  # Map to first available subnet
  subnet_mapping {
    subnet_id = data.aws_subnet_ids.default.ids[0]
  }

  # Listen on 80 (HTTP) and forward to the target group
  listener {
    port     = 80
    protocol = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.webapp_tg.arn
    }
  }
}