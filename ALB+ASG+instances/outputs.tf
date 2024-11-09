output "all_subnet_ids" {
  description = "List of all Subnet IDs in the current region"
  value       = data.aws_subnets.current_region.ids
}

output "web_load_balancer_url" {
  description = "The URL of the web load balancer"
  value       = aws_lb.web.dns_name
}