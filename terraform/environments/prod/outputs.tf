output "vpc_id" {
  description = "ID da VPC do ambiente prod"
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "IDs das sub-redes privadas do ambiente prod"
  value       = module.network.private_subnet_ids
}

output "cluster_arn" {
  description = "ARN do ECS Cluster do ambiente prod"
  value       = module.compute.cluster_arn
}

output "ecr_repository_url" {
  description = "URL do repositorio ECR do ambiente prod"
  value       = module.compute.ecr_repository_url
}

output "log_group_name" {
  description = "Nome do CloudWatch Log Group do ambiente prod"
  value       = module.compute.log_group_name
}
