variable "aws_region" {
  description = "The AWS region to deploy the infrastructure to."
  type        = string
}

variable "environment" {
  description = "A name tag for the environment."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_cidrs" {
  description = "A list of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_cidrs" {
  description = "A list of CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones to use."
  type        = list(string)
}

variable "app_container_image" {
  description = "The container image URI for the SimpleTimeService (e.g., dockerhub/image:tag)."
  type        = string
}

variable "app_container_port" {
  description = "The port the containerized application is listening on."
  type        = number
}