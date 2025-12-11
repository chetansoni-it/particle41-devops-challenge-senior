# 1. VPC and Networking (using the popular community module for simplicity)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_cidrs
  private_subnets = var.private_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1 # Tag required for Load Balancer to auto-discover
  }
}

# 2. ECS Cluster (The ECS control plane)
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"
}

# 3. Security Group for the Fargate Tasks (Allows outbound access and inbound from the ALB)
resource "aws_security_group" "ecs_task_sg" {
  # ... configuration details
}

# 4. ECS Task Definition (Defines the container, image, CPU, Memory, and network mode)
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.environment}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  # ... other configurations including container definition JSON
}

# 5. Application Load Balancer (ALB)
# The ALB is deployed in the PUBLIC subnets.
resource "aws_lb" "app_alb" {
  name               = "${var.environment}-alb"
  subnets            = module.vpc.public_subnets # Must be in public subnets
  # ... configuration details
}

# 6. Target Group and Listener (Routing traffic to the container)
resource "aws_lb_target_group" "app_tg" {
  # ... configuration details
}

resource "aws_lb_listener" "http" {
  # ... configuration to route to the Target Group
}

# 7. ECS Service (Deploys and maintains the desired count of tasks)
resource "aws_ecs_service" "app_service" {
  name            = "${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 2 # Running on private subnets
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.private_subnets # Tasks must be on PRIVATE subnets
    security_groups = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "simple-time-service"
    container_port   = var.app_container_port
  }
}