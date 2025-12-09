data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.main.id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.ec2_security_group_id]
  associate_public_ip_address = false

  # Recommended: specify a key name for SSH access
  key_name = var.key_name

  # Optional: enable root block device configuration
  root_block_device {
    volume_type = "gp3"
    volume_size = 16
    encrypted   = true
  }

  # Optional: add user_data for bootstrapping (cloud-init, etc.)
  user_data = file("${path.module}/user_data.sh")

  # Optional: specify EBS optimization
  ebs_optimized = true

  # Optional: enable/attach instance metadata options for security best practices
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = {
    Name = "main-ec2"
    Environment = var.environment
  }
}




