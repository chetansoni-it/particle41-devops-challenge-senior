# AWS Configuration
aws_region    = "us-east-1"
environment   = "devop-challenge"

# Networking Configuration
vpc_cidr      = "10.0.0.0/16"
public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

# ECS/Application Configuration
app_container_image = "<YOUR_DOCKERHUB_USERNAME>/simple-time-service:latest"
app_container_port  = 8080