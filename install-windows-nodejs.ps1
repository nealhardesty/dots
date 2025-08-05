# Install Node.js using Chocolatey

# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Please install Chocolatey first." -ForegroundColor Red
    Write-Host "Run: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -ForegroundColor Yellow
    exit 1
}

# Check if Node.js is already installed
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
  choco upgrade nodejs -y
} else {
  choco install nodejs -y
}
RefreshEnv
