output "web_alb_dns" {
  value = aws_lb.web_alb.dns_name
}
