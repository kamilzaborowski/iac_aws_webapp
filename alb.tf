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
  name               = "webapp-lb"
  load_balancer_type = "application"
  subnets            = aws_security_group.webapp_sg.id
}

# Listen on 80 (HTTP) and forward to the target group

resource "aws_lb_listener" "alb_listener" {
  depends_on        = [aws_lb.webapp_lb, aws_lb_target_group.webapp_tg]
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tg.arn
  }
}
#Attach target group to ASG
resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  depends_on       = [aws_lb_target_group.webapp_tg, aws_autoscaling_group.webapp_asg]
  target_group_arn = aws_lb_target_group.webapp_tg.arn
  port             = 80
  target_id        = aws_autoscaling_group.webapp_asg.id
}