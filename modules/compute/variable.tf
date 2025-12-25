variable "environment" {
  description = "Environment name"
  type        = string
}

variable "api_versions" {
  description = "List of API versions to support"
  type        = list(string)
}

variable "backend_endpoint" {
  description = "Backend EC2 endpoint (e.g., http://ec2-ip:8080)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}


variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  type        = string
}

