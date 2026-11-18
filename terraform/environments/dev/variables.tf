variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "Zonas de disponibilidade para as sub-redes"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "project_name" {
  description = "Prefixo do projeto, aplicado a todos os recursos"
  type        = string
  default     = "irede-mvp-7"
}

variable "environment" {
  description = "Ambiente de execucao"
  type        = string
  default     = "dev"
}

variable "cpu" {
  description = "CPU alocada para a Task Definition (unidades Fargate)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memoria alocada para a Task Definition (MB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Numero de tarefas ECS em execucao"
  type        = number
  default     = 1
}
