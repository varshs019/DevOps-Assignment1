# Run this script as Administrator (Right-click -> Run as Administrator)
# Fixes Docker Desktop by enabling required Windows features for WSL 2

Write-Host "Enabling Windows features for Docker/WSL 2..." -ForegroundColor Yellow

# Enable Virtual Machine Platform (required for WSL 2)
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Enable Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

Write-Host "`nFeatures enabled. Please RESTART your computer, then:" -ForegroundColor Green
Write-Host "1. Run: wsl --update" -ForegroundColor Cyan
Write-Host "2. Start Docker Desktop" -ForegroundColor Cyan
Write-Host "3. Wait for Docker to be ready, then run: docker compose up --build" -ForegroundColor Cyan
