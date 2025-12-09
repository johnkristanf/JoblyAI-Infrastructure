# When using API Gateway as a front door to a private EC2 instance, inbound HTTPS (443) ingress
# is NOT required unless you want to access the EC2 instance directly from the outside.
# Typically, you only need to allow inbound from internal sources or the load balancer/ALB/integration used by API Gateway.
# Remove HTTP/HTTPS open to the world. Allow as restrictive as possible.

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow inbound SSH (optional, restrict to your IP) and allow only internal inbound as needed for API Gateway/private integration"
  vpc_id      = aws_vpc.main.id

  # Optional: Allow SSH access (highly recommended to restrict to your IP)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your office/home IP for best security
  }

  # Only allow incoming traffic from internal sources (e.g., VPC) as needed
  # If using VPC Link or Private Integration, allow from the VPC or ALB/NLB security group
  # As an example, allow all from the VPC's CIDR (tighten this further if possible)
  ingress {
    description = "Allow HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # No public HTTPS/HTTP access opened.

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

