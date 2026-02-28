# DevOps Assignment

A full-stack application with FastAPI backend and Next.js frontend, deployed on AWS and Azure via Infrastructure as Code.

## Architecture Overview

- **Backend:** FastAPI (Python) – `/api/health`, `/api/message`
- **Frontend:** Next.js (React) – calls backend API
- **Deployment:** AWS (ECS Fargate) + Azure (Container Apps)
- **IaC:** Terraform for both clouds
- **CI/CD:** GitHub Actions (build, push, Terraform)

## Project Structure

```
.
├── backend/           # FastAPI backend
├── frontend/          # Next.js frontend
├── terraform/
│   ├── aws/           # ECS Fargate, ALB, ECR
│   └── azure/         # Container Apps, ACR
├── .github/workflows/ # CI/CD pipelines
└── scripts/           # Deployment scripts
```

## Quick Start (Local)

### Backend
```powershell
cd backend
.\venv\Scripts\Activate.ps1
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### Frontend
```powershell
cd frontend
npm install
npm run dev
```

Open http://localhost:3000

## Docker (Local)

```powershell
docker compose up --build
```

- Frontend: http://localhost:3000
- Backend: http://localhost:8000

## Deployment (AWS / Azure)

1. Configure credentials – see [terraform/CREDENTIALS.md](terraform/CREDENTIALS.md)
2. Deploy Terraform:
   ```powershell
   cd terraform/aws
   terraform init
   terraform plan -var="environment=dev"
   terraform apply -var="environment=dev"
   ```
3. Push images (or use GitHub Actions after adding secrets)

## Hosted URLs

| Environment | AWS | Azure |
|-------------|-----|-------|
| dev | _(add after deploy)_ | _(add after deploy)_ |
| staging | _(add after deploy)_ | _(add after deploy)_ |
| prod | _(add after deploy)_ | _(add after deploy)_ |

## Documentation

- [Architecture & Infrastructure](docs/ARCHITECTURE.md)
- [Terraform](terraform/README.md)
- [Credentials Setup](terraform/CREDENTIALS.md)
- [GitHub Secrets](docs/GITHUB-SECRETS.md)
- [Demo Video Script](docs/DEMO-VIDEO-SCRIPT.md)
- [Submission Checklist](docs/SUBMISSION-CHECKLIST.md)

## API Endpoints

- `GET /api/health` – Health check
- `GET /api/message` – Integration message
