# 🧑‍💻 Particle41 DevOps Challenge - SimpleTimeService

This repository contains the solution for the Particle41 DevOps Team Challenge, consisting of a simple time microservice (SimpleTimeService) and the Terraform infrastructure required to deploy it to AWS ECS/Fargate.

---

## 🎯 Project Overview

**SimpleTimeService:** A minimalist web service, built in Python, that returns the current timestamp and the visitor's IP address in JSON format.

**Infrastructure:** Deployed using Terraform to AWS, utilizing ECS (Fargate Launch Type) for serverless container hosting, fronted by an Application Load Balancer (ALB) for high availability and accessibility.

## 🛠️ Prerequisites

The following tools are required to build, deploy, and verify the solution:

1.  **Git:** For cloning the repository.
2.  **Docker:** For building and testing the container image.
3.  **Terraform (v1.x+):** For provisioning the AWS infrastructure.
    * [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
4.  **AWS CLI:** For managing AWS credentials.
    * [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## 🔑 AWS Authentication

The Terraform deployment requires AWS credentials configured on your machine. We recommend using an IAM User with appropriate permissions (e.g., AdministratorAccess for a challenge environment).

Configure your credentials using the AWS CLI:

```bash
aws configure
# Enter your AWS Access Key ID and Secret Access Key
```
Terraform will automatically use the credentials configured in your environment.

## 🚀 Deployment Instructions

### Part 1: Application and Container
Build the Docker Image: Navigate to the app/ directory and build the image. This command builds the image using the Dockerfile and tags it.

```bash
cd app
docker build -t <YOUR_DOCKERHUB_USERNAME>/simple-time-service:latest .
```

```bash
docker run -d -p 8080:8080 <YOUR_DOCKERHUB_USERNAME>/simple-time-service:latest
curl http://localhost:8080
# Expected output: {"timestamp": "...", "ip": "..."}
```

Push the Image to DockerHub (or equivalent): Log in and push the image so Terraform can pull it for the ECS deployment.

```bash
docker push <YOUR_DOCKERHUB_USERNAME>/simple-time-service:latest
```

### Part 2: Terraform Infrastructure
Initialize Terraform: Navigate to the terraform/ directory and initialize the backend and providers.

```bash
cd ../terraform
terraform init
```
Review the Plan: Examine the infrastructure Terraform plans to create.

```bash
terraform plan
```
Deploy the Infrastructure: Apply the plan to create the VPC, ECS cluster, Load Balancer, and deploy the application .

```bash
terraform apply -auto-approve
```
## ✅ Verification
Once terraform apply is complete, the public URL of the application will be printed as a Terraform output.

Get the URL: Retrieve the Load Balancer DNS name:

```bash
terraform output alb_dns_name
```
Access the Service: Open the URL in a browser or use curl:

```bash
curl http://<ALB_DNS_NAME>
# Expected output: {"timestamp": "...", "ip": "<ALB_IP_ADDRESS>"}
```
## 🧹 Cleanup
To avoid incurring cloud costs, ensure you destroy the resources once testing is complete.

```bash
cd terraform
terraform destroy -auto-approve
