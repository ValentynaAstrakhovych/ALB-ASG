# Define the auto-scaling group
resource "aws_autoscaling_group" "web-servers" {
  name = "web-servers-asg"
  launch_template {
    id      = aws_launch_template.web-server.id
    version = "$Latest"
  }
  max_size            = 3
  min_size            = 1
  default_cooldown     = 60  # Cooldown period in seconds

  target_group_arns   = [aws_lb_target_group.web_servers.arn]
  vpc_zone_identifier = [element(data.aws_subnets.current_region.ids, 0), element(data.aws_subnets.current_region.ids, 2), element(data.aws_subnets.current_region.ids, 3)] # Replace with your subnet IDs
  
  tag {
    key                 = "Environment"
    value               = "production"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out_in_dynamic" {
  name                      = "scale_out_in_dynamic"
  autoscaling_group_name    = aws_autoscaling_group.web-servers.id
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 22.0
  }
}