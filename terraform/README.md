# Terraform - AWS & Azure Infrastructure

Infrastructure as Code for deploying the DevOps Assignment app on **AWS** and **Azure**.

## Architecture Overview

### AWS (ECS Fargate)
- **Region:** us-east-1 (configurable)
- **Compute:** ECS Fargate (managed containers)
- **Networking:** Application Load Balancer, path-based routing (`/api/*` → backend, `/*` → frontend)
- **Registry:** Amazon ECR
- **State:** S3 + DynamoDB (see backend.tf.example)

### Azure (Container Apps)
- **Region:** eastus (configurable)
- **Compute:** Azure Container Apps (serverless containers)
- **Registry:** Azure Container Registry
- **State:** Azure Storage (see backend.tf.example)

## Environments

Each cloud supports: **dev**, **staging**, **prod**

| Environment | AWS ECS replicas | Azure min replicas | Scaling |
|-------------|------------------|--------------------|---------|
| dev        | 1                | 0 (scale to zero)  | 0–3     |
| staging    | 1                | 0                  | 0–3     |
| prod       | 2                | 2                  | 2–10    |

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- AWS CLI configured (`aws configure`)
- Azure CLI configured (`az login`)

## AWS Deployment

```bash
cd terraform/aws

# Initialize
terraform init

# Create S3 bucket + DynamoDB for state (one-time), then copy backend.tf.example to backend.tf

# Plan (dev)
terraform plan -var-file=dev.tfvars -var="environment=dev"

# Apply
terraform apply -var-file=dev.tfvars -var="environment=dev"

# Push images to ECR first (see CI/CD or manual steps)
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com
# docker build -t <ecr-url>/devops-assignment-backend:latest ./backend
# docker push <ecr-url>/devops-assignment-backend:latest
# (Repeat for frontend - build with NEXT_PUBLIC_API_URL=http://<alb-dns-name>)
```

## Azure Deployment

```bash
cd terraform/azure

# Initialize
terraform init

# Plan (dev)
terraform plan -var-file=dev.tfvars -var="environment=dev"

# Apply
terraform apply -var-file=dev.tfvars -var="environment=dev"

# Push images to ACR
# az acr login --name <acr-name>
# docker build -t <acr>.azurecr.io/devops-assignment-backend:latest ./backend
# docker push <acr>.azurecr.io/devops-assignment-backend:latest
# (Frontend: build with NEXT_PUBLIC_API_URL=https://<backend-fqdn>)
```

## State Management

- **AWS:** S3 bucket + DynamoDB table for locking
- **Azure:** Storage account + container
- **Isolation:** Separate state key per environment (e.g., `dev/terraform.tfstate`, `prod/terraform.tfstate`)

## Frontend Build Note

`NEXT_PUBLIC_API_URL` is baked into the Next.js client at **build time**. You must build the frontend image with the correct backend URL:

- **AWS:** `NEXT_PUBLIC_API_URL=http://<alb-dns-name>`
- **Azure:** `NEXT_PUBLIC_API_URL=https://<backend-container-app-fqdn>`
