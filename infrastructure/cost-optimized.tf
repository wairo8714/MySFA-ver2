# Cost-optimized configuration for development and testing

# More cost-effective RDS configuration
resource "aws_db_instance" "cost_optimized" {
  count = var.use_cost_optimized ? 1 : 0
  
  identifier = "${var.project_name}-mysql-cost-optimized"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 1
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = true
  deletion_protection = false

  auto_minor_version_upgrade = false

  tags = {
    Name = "${var.project_name}-mysql-cost-optimized"
  }
}

# More cost-effective ECS configuration
resource "aws_ecs_task_definition" "cost_optimized" {
  count = var.use_cost_optimized ? 1 : 0
  
  family                   = "${var.project_name}-task-cost-optimized"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-container"
      image = "${var.dockerhub_username}/mysfa_ver2:latest"
      
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]

      environment = [
        {
          name  = "MYSQL_HOST"
          value = var.use_cost_optimized ? aws_db_instance.cost_optimized[0].endpoint : aws_db_instance.main.endpoint
        },
        {
          name  = "MYSQL_PORT"
          value = "3306"
        },
        {
          name  = "MYSQL_DATABASE"
          value = var.db_name
        },
        {
          name  = "MYSQL_USER"
          value = var.db_username
        },
        {
          name  = "MYSQL_PASSWORD"
          value = var.db_password
        },
        {
          name  = "SECRET_KEY"
          value = var.secret_key
        },
        {
          name  = "DEBUG"
          value = "False"
        },
        {
          name  = "ALLOWED_HOSTS"
          value = var.allowed_hosts
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.main.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-task-cost-optimized"
  }
}

# Scheduled stop for development environment
resource "aws_events_rule" "stop_ecs" {
  count = var.use_cost_optimized ? 1 : 0
  
  name                = "${var.project_name}-stop-ecs"
  description         = "Stop ECS service at night"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_events_target" "stop_ecs" {
  count = var.use_cost_optimized ? 1 : 0
  
  rule      = aws_events_rule.stop_ecs[0].name
  target_id = "StopECSTarget"
  arn       = aws_ecs_service.main_with_alb.id
}

resource "aws_events_rule" "start_ecs" {
  count = var.use_cost_optimized ? 1 : 0
  
  name                = "${var.project_name}-start-ecs"
  description         = "Start ECS service in morning"
  schedule_expression = "cron(0 8 * * ? *)"
}
