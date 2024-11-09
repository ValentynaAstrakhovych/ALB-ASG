resource "aws_launch_template" "web-server" {
  name_prefix            = "web-server-"
  image_id               = data.aws_ami.latest_ubuntu.id # Replace with your desired AMI
  instance_type          = "c6a.large"                   # Replace with your desired instance type
  user_data              = filebase64("user_data.sh")
  key_name               = "lesson_7_ansible" # your ssh key name
  vpc_security_group_ids = [aws_security_group.web_server.id]

  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ASG Test instance"
    }
  }
}