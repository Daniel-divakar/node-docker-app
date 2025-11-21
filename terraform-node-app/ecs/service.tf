###############################
# ECS Service (Fargate)
###############################
resource "aws_ecs_service" "service" {
  name            = "fargate-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  # The ALB target group is wired through the module call
load_balancer {
  target_group_arn = var.target_group_arn
  container_name   = "myapp"            # ✅ matches task definition
  container_port   = var.container_port
}
  depends_on = [var.listener_arn]
}

###############################
# Outputs
###############################
output "service_id" {
  value = aws_ecs_service.service.id
}

output "service_name" {
  value = aws_ecs_service.service.name
}

# Helpful output for attachments (used in main, optional)
output "service_network_target" {
  value = aws_ecs_service.service.id
}
