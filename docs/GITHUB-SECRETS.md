# GitHub Secrets Setup

Add these secrets in **Settings → Secrets and variables → Actions** for CI/CD.

## AWS (Build & Push, Terraform)

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | IAM user access key with ECR push + ECS permissions |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |

**Create IAM user:**
1. IAM → Users → Create user
2. Attach policies: `AmazonEC2ContainerRegistryFullAccess`, `AmazonECS_FullAccess`, `ElasticLoadBalancingFullAccess`
3. Create access key → copy both values

## Azure (Build & Push, Terraform)

| Secret | Description |
|--------|-------------|
| `AZURE_CREDENTIALS` | Service principal JSON |
| `ACR_LOGIN_SERVER` | ACR login server (e.g., `devopsassignmentdevacr.azurecr.io`) |

**Create service principal:**
```bash
az ad sp create-for-rbac --name "github-actions-devops" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{rg} --sdk-auth
```
Copy the full JSON output as `AZURE_CREDENTIALS`.

**ACR_LOGIN_SERVER:** After `terraform apply`, run `terraform output acr_login_server` and copy the value.
