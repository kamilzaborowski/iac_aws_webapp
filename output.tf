# After infrastructure creation, gather DNS to access web application via ALB
output "aws_lb_dns" {
  description = "DNS for ALB"
  value       = aws_lb.webapp_lb.dns_name
}