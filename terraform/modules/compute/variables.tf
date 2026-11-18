variable "vpc_id" {
  description = "ID da VPC onde os recursos de compute serao criados"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das sub-redes privadas para o ECS Service"
  type        = list(string)
}

variable "project_name" {
  description = "Nome do projeto, usado como prefixo nos recursos"
  type        = string
  default     = "irede-mvp-7"
}

variable "environment" {
  description = "Ambiente de execucao (dev ou prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "O ambiente deve ser 'dev' ou 'prod'."
  }
}

variable "cpu" {
  description = "CPU alocada para a Task Definition (unidades Fargate: 256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memoria alocada para a Task Definition em MB (ex: 512, 1024, 2048)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Numero de tarefas ECS que devem ficar rodando simultaneamente"
  type        = number
  default     = 1
}

variable "container_port" {
  description = "Porta exposta pelo container da aplicacao Java"
  type        = number
  default     = 8080
}

variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados"
  type        = string
  default     = "us-east-1"
}
