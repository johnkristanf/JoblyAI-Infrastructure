variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
}

variable "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  type        = string
}

