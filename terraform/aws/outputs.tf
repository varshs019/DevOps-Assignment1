output "lb_url" {
  description = "Application Load Balancer URL (use for frontend NEXT_PUBLIC_API_URL when building image)"
  value       = "http://${aws_lb.main.dns_name}"
}

output "backend_ecr_repository_url" {
  description = "ECR repository URL for backend images"
  value       = aws_ecr_repository.backend.repository_url
}

output "frontend_ecr_repository_url" {
  description = "ECR repository URL for frontend images"
  value       = aws_ecr_repository.frontend.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}
