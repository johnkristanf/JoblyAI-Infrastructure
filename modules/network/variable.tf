variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "primary_availability_zone" {
  description = "Primary availability zone for both public and private subnet"
  type        = string
  default     = "ap-southeast-1a"
}

variable "secondary_availability_zone" {
  description = "Secondary availability zone for private subnet"
  type        = string
  default     = "ap-southeast-1b"
}

variable "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  type        = string
}

