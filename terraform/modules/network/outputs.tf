output "vpc_id" {
  description = "Identificador da VPC"
  value       = aws_vpc.this.id
}

output "subnet_public_id" {
  description = "Identificador da sub-rede publica"
  value       = aws_subnet.public.id
}

output "subnet_private_1_id" {
  description = "Identificador da sub-rede privada 1"
  value       = aws_subnet.private_1.id
}

output "subnet_private_2_id" {
  description = "Identificador da sub-rede privada 2"
  value       = aws_subnet.private_2.id
}

# Lista das sub-redes privadas — consumida pelo modulo compute
output "private_subnet_ids" {
  description = "Lista com os IDs das sub-redes privadas"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "internet_gateway_id" {
  description = "Identificador do Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "route_table_public_id" {
  description = "Identificador da tabela de rotas publica"
  value       = aws_route_table.public.id
}
