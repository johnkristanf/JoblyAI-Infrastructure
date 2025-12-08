variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "api_versions" {
  description = "List of API versions to support"
  type        = list(string)
  default     = ["/api/v1", "/api/v2"]
}