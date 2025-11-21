variable "cluster_name" { type = string }
variable "task_family" { type = string }
variable "ecr_image_url" { type = string }
variable "container_port" { type = number }
variable "private_subnets" { type = list(string) }
variable "ecs_security_group_id" { type = string }
variable "execution_role_arn" { type = string }
variable "region" { type = string }
variable "log_group_name" { type = string }

# ALB integration
variable "target_group_arn" { type = string }
variable "listener_arn" { type = string }
