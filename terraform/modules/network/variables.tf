variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "Lista de zonas de disponibilidade para distribuicao das sub-redes"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  validation {
    condition     = length(var.azs) > 0
    error_message = "A lista de zonas de disponibilidade nao pode estar vazia."
  }
}

variable "project_tag" {
  description = "Tag de projeto aplicada a todos os recursos"
  type        = string
  default     = "Atividade-Pratica-03"
}

variable "environment_tag" {
  description = "Tag de ambiente aplicada a todos os recursos"
  type        = string
  default     = "lab"
}
