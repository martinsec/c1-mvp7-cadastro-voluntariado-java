locals {
  common_tags = {
    Project     = var.project_tag
    Environment = var.environment_tag
    ManagedBy   = "Terraform"
    MVP         = "MVP4"
  }
}

# -------------------------------------------------------------------
# VPC principal — bloco 10.40.0.0/16
# -------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = "10.40.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = merge(local.common_tags, {
    Name = "irede-mvp-4-vpc"
  })
}

# -------------------------------------------------------------------
# Sub-rede publica — 10.40.1.0/24 — us-east-1a
# Recursos lancados aqui recebem IPv4 publico automaticamente
# -------------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.40.1.0/24"
  availability_zone       = element(var.azs, 0)
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "irede-mvp-4-subnet-public"
  })
}

# -------------------------------------------------------------------
# Sub-rede privada 1 — 10.40.10.0/24 — us-east-1b
# Sem atribuicao automatica de IP publico
# -------------------------------------------------------------------
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.40.10.0/24"
  availability_zone       = element(var.azs, 1)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "irede-mvp-4-subnet-private-1"
  })
}

# -------------------------------------------------------------------
# Sub-rede privada 2 — 10.40.20.0/24 — us-east-1c
# Sem atribuicao automatica de IP publico
# -------------------------------------------------------------------
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.40.20.0/24"
  availability_zone       = element(var.azs, 2)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "irede-mvp-4-subnet-private-2"
  })
}

# -------------------------------------------------------------------
# Internet Gateway — conecta a VPC a internet
# -------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "irede-mvp-4-igw"
  })
}

# -------------------------------------------------------------------
# Tabela de rotas publica
# -------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "irede-mvp-4-rt-public"
  })
}

# Rota padrao: trafego de saida (0.0.0.0/0) vai para o Internet Gateway
resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associa a tabela publica APENAS a sub-rede publica
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}
