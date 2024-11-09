
# Create Application Load Balancer (ALB) to distribute incoming HTTP traffic across instances
resource "aws_lb" "web" {
  name               = "web-server-lb"
  load_balancer_type = "network" # Network LB (Layer 3) or optional Application LB (Layer 7)
  security_groups    = [aws_security_group.web_server.id]
  subnets            = [element(data.aws_subnets.current_region.ids, 0), element(data.aws_subnets.current_region.ids, 2), element(data.aws_subnets.current_region.ids, 3)]
  internal           = false
}

# Create target group
resource "aws_lb_target_group" "web_servers" {
  name     = "web-server-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP" # GET request default port 80
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = {
    Name = "web-server-target-group"
  }
}

# Create a listener for the NLB
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}
