<#
.SYNOPSIS
    Installs and configures OpenSSH Server to launch the first WSL2 distro as the default shell,
    using the current Windows username for SSH logins.

    Make sure to run this script as Administrator.

    Make sure to enable execution of scripts in the PowerShell settings.
        Set-ExecutionPolicy Unrestricted -Scope Process -Force
#>

# Ensure script is running elevated
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script As Administrator."
    exit 1
}

# 1. Install OpenSSH Server
Write-Host "Installing OpenSSH Server..." -ForegroundColor Green
Get-WindowsCapability -Online | Where-Object Name -Like 'OpenSSH*' | ForEach-Object { 
    Write-Host "Installing windows capability $($_.Name)..." -ForegroundColor Cyan
    Add-WindowsCapability -Online -Name $_.Name 
}

# 2. Start service and set to automatic
Write-Host "Starting sshd service and setting to automatic..." -ForegroundColor Green
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# 3. Ensure firewall rule exists
Write-Host "Ensuring firewall rule for SSH..." -ForegroundColor Green
if (-not (Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' `
        -DisplayName 'OpenSSH SSH Server' `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22
} else {
    Write-Host "Firewall rule already present." -ForegroundColor Yellow
}

# 4. Detect first WSL distro name
Write-Host "Detecting first WSL distro..." -ForegroundColor Green
# Use quiet list to get only names
$firstDistro = wsl.exe -l -q | Select-Object -First 1
if (-not $firstDistro) {
    Write-Error "No WSL distros found. Please install a WSL2 distro first."
    exit 1
}
Write-Host "First WSL distro detected: $firstDistro" -ForegroundColor Cyan

# 5. Determine current Windows username
$currentUser = $env:USERNAME
Write-Host "Using username: $currentUser" -ForegroundColor Cyan

# 6. Configure OpenSSH DefaultShell registry keys
Write-Host "Writing registry keys for DefaultShell..." -ForegroundColor Green
$regPath = 'HKLM:\SOFTWARE\OpenSSH'

# Ensure key exists
if (-not (Test-Path $regPath)) { 
    New-Item -Path $regPath -Force | Out-Null 
}

# DefaultShell → wsl.exe 
New-ItemProperty -Path $regPath `
    -Name DefaultShell `
    -Value 'C:\Windows\System32\wsl.exe' `
    -PropertyType String `
    -Force

# DefaultShellCommandOption → arguments: –d <distro> –u <user>
$option = "-d $firstDistro -u $currentUser"
New-ItemProperty -Path $regPath `
    -Name DefaultShellCommandOption `
    -Value $option `
    -PropertyType String `
    -Force

# 7. Display completion message and instructions
Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "SSH to this Windows host and you will land in WSL2 distro '$firstDistro' as user '$currentUser'." -ForegroundColor White
Write-Host ""
  