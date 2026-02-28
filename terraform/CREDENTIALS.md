# Terraform Credentials Setup

Terraform init completed. To run `plan` or `apply`, configure credentials:

## AWS

1. Install [AWS CLI](https://aws.amazon.com/cli/)
2. Run: `aws configure`
3. Enter:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region: `us-east-1`

Or set environment variables:
```
$env:AWS_ACCESS_KEY_ID = "your-key"
$env:AWS_SECRET_ACCESS_KEY = "your-secret"
$env:AWS_DEFAULT_REGION = "us-east-1"
```

## Azure

1. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. Run: `az login`
3. Select your subscription: `az account set --subscription "Your Subscription"`

## Run Terraform

```powershell
# Plan (preview changes)
cd terraform\aws
terraform plan -var="environment=dev"

cd ..\azure
terraform plan -var="environment=dev"

# Apply (create resources - costs money!)
terraform apply -var="environment=dev"
```

Or use the script:
```powershell
.\scripts\deploy-terraform.ps1 -Cloud aws -Environment dev -Action plan
```
