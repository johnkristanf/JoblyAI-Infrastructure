output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "secondary_private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.secondary_private.id
}


output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "alb_http_listener_arn" {
  description = "ALB's HTTP listener resource name"
  value       = aws_lb_listener.http_listener.arn
}