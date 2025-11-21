###############################
# Target Group (IP mode for Fargate)
###############################
resource "aws_lb_target_group" "tg" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

###############################
# Outputs
###############################
output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}
