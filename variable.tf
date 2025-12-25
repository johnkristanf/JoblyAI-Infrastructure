variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  sensitive = true
}

variable "profile" {
  description = "The AWS profile"
  type        = string
  sensitive = true
}