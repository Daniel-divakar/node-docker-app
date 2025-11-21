module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "node-app-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets_cidrs
  private_subnets = var.private_subnets_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = { Tier = "public" }
  private_subnet_tags = { Tier = "private" }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "alb-sg" }
}

# ECS SG — allow inbound from ALB to container port
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow ALB to ECS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "ALB to ECS"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "ecs-sg" }
}

# IAM roles
module "iam" {
  source = "./iam"
}

# ECS cluster, task def, service
module "ecs" {
  source                = "./ecs"
  cluster_name          = var.cluster_name
  task_family           = var.task_family
  ecr_image_url         = var.ecr_image_url
  container_port        = var.container_port
  private_subnets       = module.vpc.private_subnets
  ecs_security_group_id = aws_security_group.ecs_sg.id
  execution_role_arn    = module.iam.execution_role_arn
  log_group_name        = var.log_group_name
  target_group_arn      = module.alb.target_group_arn
  listener_arn          = module.alb.listener_arn
  region                = var.region
}

# ALB
module "alb" {
  source             = "./alb"
  alb_name           = var.alb_name
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  alb_security_group = aws_security_group.alb_sg.id
  target_group_name  = var.target_group_name
  container_port     = var.container_port
}

