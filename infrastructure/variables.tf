variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "mysfa"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mysfa_db"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Django secret key"
  type        = string
  sensitive   = true
}

variable "allowed_hosts" {
  description = "Django allowed hosts"
  type        = string
  default     = "*"
}

variable "ecs_cpu" {
  description = "ECS task CPU"
  type        = number
  default     = 256
}

variable "ecs_memory" {
  description = "ECS task memory"
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "ECS service desired count"
  type        = number
  default     = 1
}

variable "dockerhub_username" {
  description = "DockerHub username"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}
