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