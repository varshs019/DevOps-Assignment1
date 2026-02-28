# Demo Video Script (8-12 minutes)

Use this outline when recording your demo video.

## 1. Introduction (1 min)

- Your name and role
- DevOps assignment overview
- Repo: forked from PG-AGI/DevOps-Assignment

## 2. Architecture Walkthrough (2-3 min)

- AWS: ECS Fargate, ALB, ECR, path-based routing
- Azure: Container Apps, ACR
- Compute choice: Why ECS/Container Apps vs Kubernetes

## 3. Cloud and Region (1 min)

- AWS us-east-1: mature region, broad support
- Azure eastus: primary US region
- Tradeoffs: latency, cost, growth

## 4. Infrastructure (2 min)

- Environments: dev, staging, prod
- State: S3+DynamoDB, Azure Storage
- Security: secrets, least privilege

## 5. Deployment Flow (2 min)

- Local run
- Docker
- CI/CD and GitHub Actions

## 6. Scaling and Failure (1-2 min)

- Auto-scaling by environment
- Health checks, rollback
- What breaks and what recovers

## 7. Future Growth (1 min)

- 10x traffic, new services
- What changes vs stays the same

## 8. What We Did NOT Do (1 min)

- Kubernetes, multi-region, database
- Rationale for each

## 9. Live Demo (2-3 min)

- Local app: http://localhost:3000
- Hosted URLs (AWS and Azure)
- API: /api/health, /api/message
