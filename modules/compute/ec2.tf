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

resource "aws_key_pair" "main" {
  key_name = "joblyai-key-pair"
  public_key = file("~/.ssh/joblyai-key-pair.pub")
}

# If availability zone of this instance is not specified, by default, it 
# uses the subnet's az
resource "aws_instance" "main" {
  ami                         = data.aws_ami.main.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.ec2_security_group_id]

  iam_instance_profile = var.ec2_profile_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  # Recommended: specify a key name for SSH access
  key_name = aws_key_pair.main.key_name

  # Optional: enable root block device configuration
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  # Optional: add user_data for bootstrapping (cloud-init, etc.)
  user_data = file("${path.module}/user_data.sh")
  tags = {
    Name = "main-ec2"
    Environment = var.environment
  }
}




