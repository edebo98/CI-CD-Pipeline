output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the main VPC"
}

output "public_subnets" {
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  description = "IDs of the public subnets"
}

output "security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "ID of the web security group"
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.app_repo.repository_url
  description = "URL of the ECR repository"
}

output "ecs_cluster_id" {
  value       = aws_ecs_cluster.main.id
  description = "ID of the ECS cluster"
}

output "ecs_service_name" {
  value       = aws_ecs_service.app.name
  description = "Name of the ECS service"
}

output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "alb_arn" {
  value       = aws_lb.app.arn
  description = "ARN of the Application Load Balancer"
}
