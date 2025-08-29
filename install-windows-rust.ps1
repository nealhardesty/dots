# Install Rust on Windows using Chocolatey
# This script will install Chocolatey (if not already installed) and then install Rust

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run as administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Installing Rust ..." -ForegroundColor Gree

# Install Rust using Chocolatey
Write-Host "Installing Rust..." -ForegroundColor Yellow
choco install rust -y

if ($LASTEXITCODE -eq 0) {
    Write-Host "Rust installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To verify the installation, open a new PowerShell window and run:" -ForegroundColor Cyan
    Write-Host "  rustc --version" -ForegroundColor White
    Write-Host "  cargo --version" -ForegroundColor White
    Write-Host ""
    Write-Host "You may need to restart your terminal or run 'refreshenv' to update your PATH." -ForegroundColor Yellow
} else {
    Write-Host "Failed to install Rust. Please check the error messages above." -ForegroundColor Red
    exit 1
}
