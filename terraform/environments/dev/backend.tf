# Backend S3 para o estado do ambiente DEV
# Chave isolada do prod: envs/dev/terraform.tfstate
# Descomente quando o professor autorizar o deploy

# terraform {
#   backend "s3" {
#     bucket         = "irede-mvp7-terraform-state"
#     key            = "envs/dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "irede-mvp7-tf-lock"
#     encrypt        = true
#   }
# }
