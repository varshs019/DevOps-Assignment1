# Deploy via Terraform - run after configuring credentials
# AWS: aws configure
# Azure: az login

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("aws","azure")]
    [string]$Cloud,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev","staging","prod")]
    [string]$Environment = "dev",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("plan","apply")]
    [string]$Action = "plan"
)

$TerraformDir = "$PSScriptRoot\..\terraform\$Cloud"

if (-not (Test-Path "$TerraformDir\$Environment.tfvars")) {
    Copy-Item "$TerraformDir\dev.tfvars.example" "$TerraformDir\$Environment.tfvars"
    Write-Host "Created $Environment.tfvars - edit with your image URLs" -ForegroundColor Yellow
}

Set-Location $TerraformDir

Write-Host "Terraform $Action for $Cloud ($Environment)..." -ForegroundColor Cyan
terraform init
terraform $Action -var-file="$Environment.tfvars"

if ($Action -eq "apply") {
    Write-Host "`nOutputs:" -ForegroundColor Green
    terraform output
}
