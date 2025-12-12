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
