# AWS basics
region = "ap-south-1"

# VPC settings
vpc_cidr              = "10.0.0.0/16"
azs                   = ["ap-south-1a", "ap-south-1b"]
public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# ECS / ALB settings
cluster_name       = "my-fargate-cluster"
task_family        = "my-fargate-task"

# ✅ Your ECR image URL (must match what you pushed)
ecr_image_url      = "211029160881.dkr.ecr.ap-south-1.amazonaws.com/node-docker-app:latest"

container_port     = 8900
alb_name           = "fargate-alb"
target_group_name  = "fargate-tg"
log_group_name     = "/ecs/node-app"
