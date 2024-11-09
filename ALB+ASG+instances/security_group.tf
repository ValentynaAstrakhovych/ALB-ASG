
#random_pet to generate a random name for the security group
resource "random_pet" "sg" {}

# Security group for the instances
resource "aws_security_group" "web_server" {
  name = "${random_pet.sg.id}-sg"

  # Creates ingress rules for TCP ports 22, 80, and 443
  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow ICMP traffic (PING)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group Allowed ICMP and ports: 22-80-443"
  }
}