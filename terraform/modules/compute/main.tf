locals {
  prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    MVP         = "MVP7"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -------------------------------------------------------------------
# ECR — repositorio de imagens Docker
# -------------------------------------------------------------------
resource "aws_ecr_repository" "app" {
  name                 = "${local.prefix}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ecr"
  })
}

# -------------------------------------------------------------------
# CloudWatch Log Group — recebe os logs dos containers
# -------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.prefix}"
  retention_in_days = 7

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-logs"
  })
}

# -------------------------------------------------------------------
# IAM — papel de execucao que permite ao ECS iniciar tarefas Fargate
# -------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "${local.prefix}-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-task-exec-role"
  })
}

# Politica gerenciada pela AWS: acesso ao ECR e ao CloudWatch Logs
resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -------------------------------------------------------------------
# Security Group — controla o trafego de entrada e saida das tarefas
# -------------------------------------------------------------------
resource "aws_security_group" "ecs_tasks" {
  name        = "${local.prefix}-ecs-sg"
  description = "Regras de rede para as tarefas ECS Fargate"
  vpc_id      = var.vpc_id

  # Saida: permite todo o trafego (necessario para ECR e CloudWatch via VPC Endpoints)
  egress {
    description = "Permite todo o trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada: apenas na porta da aplicacao, dentro da propria VPC
  ingress {
    description = "Porta da aplicacao Java dentro da VPC"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["10.40.0.0/16"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ecs-sg"
  })
}

# -------------------------------------------------------------------
# ECS Cluster — agrupa as tarefas Fargate
# -------------------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-cluster"
  })
}

# -------------------------------------------------------------------
# ECS Task Definition — descreve imagem, CPU, memoria e logs
# -------------------------------------------------------------------
resource "aws_ecs_task_definition" "app" {
  family                   = "${local.prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-app"
      image = "${aws_ecr_repository.app.repository_url}:latest"
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-task"
  })
}

# -------------------------------------------------------------------
# ECS Service — mantem desired_count tarefas rodando
# -------------------------------------------------------------------
resource "aws_ecs_service" "app" {
  name            = "${local.prefix}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-service"
  })
}
