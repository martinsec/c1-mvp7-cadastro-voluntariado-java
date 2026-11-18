output "cluster_arn" {
  description = "ARN do ECS Cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecr_repository_url" {
  description = "URL do repositorio ECR (usado no docker push)"
  value       = aws_ecr_repository.app.repository_url
}

output "service_name" {
  description = "Nome do ECS Service"
  value       = aws_ecs_service.app.name
}

output "task_definition_arn" {
  description = "ARN da Task Definition registrada"
  value       = aws_ecs_task_definition.app.arn
}

output "log_group_name" {
  description = "Nome do CloudWatch Log Group das tarefas"
  value       = aws_cloudwatch_log_group.ecs.name
}
