output "ec2_profile_name" {
  description = "The name of the IAM instance profile created for EC2."
  value       = aws_iam_instance_profile.ec2_profile.name
}

