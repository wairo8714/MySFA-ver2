# Ultra-low cost configuration for personal development and learning

# 1. EC2 + Docker (cheaper than ECS)
resource "aws_instance" "ultra_cheap" {
  count = var.use_ultra_cheap ? 1 : 0
  
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t4g.nano"
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.ultra_cheap[0].id]
  subnet_id              = aws_subnet.public[0].id

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    dockerhub_username = var.dockerhub_username
    mysql_host         = aws_db_instance.ultra_cheap[0].endpoint
    mysql_password     = var.db_password
    secret_key         = var.secret_key
  }))

  tags = {
    Name = "${var.project_name}-ultra-cheap"
  }
}

# 2. Minimal RDS
resource "aws_db_instance" "ultra_cheap" {
  count = var.use_ultra_cheap ? 1 : 0
  
  identifier = "${var.project_name}-mysql-ultra-cheap"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t4g.nano"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp2"
  storage_encrypted     = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.ultra_cheap_rds[0].id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "${var.project_name}-mysql-ultra-cheap"
  }
}

# Minimal security groups
resource "aws_security_group" "ultra_cheap" {
  count = var.use_ultra_cheap ? 1 : 0
  
  name_prefix = "${var.project_name}-ultra-cheap-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ultra-cheap-sg"
  }
}

resource "aws_security_group" "ultra_cheap_rds" {
  count = var.use_ultra_cheap ? 1 : 0
  
  name_prefix = "${var.project_name}-ultra-cheap-rds-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ultra_cheap[0].id]
  }

  tags = {
    Name = "${var.project_name}-ultra-cheap-rds-sg"
  }
}
