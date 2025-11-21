###############################
# ECS Cluster
###############################
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

###############################
# Outputs
###############################
output "cluster_id" {
  value = aws_ecs_cluster.this.id
}
