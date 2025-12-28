variable "environment" {
  description = "Environment name"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "secondary_private_id" {
  description = "Secondary id of the private subnet"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "alb_http_listener_arn" {
  description = "ALB's HTTP listener resource name"
  type        = string
}
