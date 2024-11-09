# Data source to get the latest Ubuntu AMI
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
}

# Data source to get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to get subnets in the current region
data "aws_subnets" "current_region" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}