# Architecture & Infrastructure Documentation

> **For assignment submission:** Copy this content to a Google Doc and expand with diagrams, screenshots, and hosted URLs. This serves as the template.

## 1. Cloud & Region Selection

### AWS
- **Region:** us-east-1 (N. Virginia)
- **Rationale:** Largest AWS region, broadest service support, competitive pricing, low latency for US users
- **Tradeoffs:** Latency for non-US users; consider eu-west-1 for EU

### Azure
- **Region:** eastus
- **Rationale:** Primary US region, full service availability, good cost-performance
- **Tradeoffs:** Similar to AWS; consider West Europe for EU

---

## 2. Compute & Runtime

### AWS – ECS Fargate
- **Choice:** Managed containers (ECS Fargate) – not Kubernetes
- **Rationale:** Serverless containers, no cluster management; fits simple app; avoids K8s overhead
- **Scaling:** Auto-scaling based on CPU/memory; min 0 for dev, 2 for prod

### Azure – Container Apps
- **Choice:** Azure Container Apps (serverless containers)
- **Rationale:** Similar to Cloud Run; scale-to-zero for dev; no VM/K8s management
- **Scaling:** Min replicas 0 (dev) to 2 (prod); max 3–10

---

## 3. Networking & Traffic Flow

### AWS
- **ALB:** Application Load Balancer with path-based routing
  - `/api/*` → Backend (port 8000)
  - `/*` → Frontend (port 3000)
- **Security groups:** Backend/frontend isolated; ALB public

### Azure
- **Ingress:** Each Container App has public FQDN
- **Frontend → Backend:** Frontend calls backend URL (set at build time)

---

## 4. Environment Separation

| Env   | AWS ECS | Azure min replicas | Purpose     |
|-------|---------|--------------------|-------------|
| dev   | 1 task  | 0                  | Development |
| staging | 1 task | 0                  | Pre-prod    |
| prod  | 2 tasks | 2                  | Production  |

---

## 5. State Management (IaC)

- **AWS:** S3 + DynamoDB for Terraform state and locking
- **Azure:** Storage account + container
- **Isolation:** Separate state key per environment
- **Locking:** Backend-provided locking (DynamoDB, blob lease)
- **Recovery:** Document restore from backup; restrict state access

---

## 6. Deployment Strategy

- **Flow:** Build images → Push to ECR/ACR → ECS/Container Apps pull new images
- **Downtime:** Rolling update; minimal if health checks pass
- **Rollback:** Revert to previous task definition / revision
- **Failure handling:** Health checks; unhealthy tasks replaced

---

## 7. Security & Identity

- **CI/CD:** Service principal / IAM role with least privilege
- **Secrets:** Cloud secret stores; never in Git or images
- **Access:** Role-based; minimal required permissions

---

## 8. Failure & Operational Behavior

- **Failure units:** Container / task
- **Self-recovery:** Health checks, auto-restart, auto-scaling
- **Human intervention:** State corruption, credential rotation, major config changes
- **Alerting:** Focus on error rate, latency, availability

---

## 9. Future Growth (10× traffic)

- **Change:** Increase scaling limits, add CDN, consider multi-region
- **Stable:** IaC layout, environment separation, networking design
- **Earlier decisions:** IaC, env separation, managed containers support scaling

---

## 10. What We Did NOT Do

- **Kubernetes:** Unnecessary for this app; ECS/Container Apps sufficient
- **Multi-region:** Out of scope; single region per cloud
- **Database:** Not required for current API
- **Custom VMs:** Managed containers reduce operational burden
