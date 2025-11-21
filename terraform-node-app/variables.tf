# AWS basics
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

# VPC settings
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets_cidrs" {
  description = "Public subnets CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidrs" {
  description = "Private subnets CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# App / ECS / ALB settings
variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "my-fargate-cluster"
}

variable "task_family" {
  description = "ECS task family"
  type        = string
  default     = "my-fargate-task"
}

variable "ecr_image_url" {
  description = "Full ECR image URL (e.g., 211029160881.dkr.ecr.ap-south-1.amazonaws.com/node-docker-app:latest)"
  type        = string
}

variable "container_port" {
  description = "Container port exposed by the app"
  type        = number
  default     = 8900
}

variable "alb_name" {
  description = "ALB name"
  type        = string
  default     = "fargate-alb"
}

variable "target_group_name" {
  description = "Target group name"
  type        = string
  default     = "fargate-tg"
}

variable "log_group_name" {
  description = "CloudWatch Logs group for ECS tasks"
  type        = string
  default     = "/ecs/node-app"
}
