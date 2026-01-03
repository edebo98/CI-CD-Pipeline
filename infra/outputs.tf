output "alb_dns" {
  value = aws_lb.app_lb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}
