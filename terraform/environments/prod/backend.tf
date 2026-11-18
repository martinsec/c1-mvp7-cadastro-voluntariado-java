# Backend S3 para o estado do ambiente PROD
# Chave diferente do dev: envs/prod/terraform.tfstate
# Descomente quando o professor autorizar o deploy

# terraform {
#   backend "s3" {
#     bucket         = "irede-mvp7-terraform-state"
#     key            = "envs/prod/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "irede-mvp7-tf-lock"
#     encrypt        = true
#   }
# }
