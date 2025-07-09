# Run as administrator: powershell -ExecutionPolicy Bypass -File install-windows-java17.ps1

# Check if running with admin privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script requires administrator privileges. Please run as administrator." -ForegroundColor Red
    exit 1
}

Write-Host "SUCCESS: Running with administrator privileges" -ForegroundColor Green

Write-Host "Installing OpenJDK 17 via winget..." -ForegroundColor Cyan

# Install Temurin JDK 17
winget install --id EclipseAdoptium.Temurin.17.JDK --source winget --accept-package-agreements --accept-source-agreements

# Attempt to find the install directory
$jdkRoot = "C:\Program Files\Eclipse Adoptium"
$jdkDir = Get-ChildItem "$jdkRoot" -Directory | Where-Object { $_.Name -like "jdk-17*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $jdkDir) {
    Write-Host "ERROR: Failed to locate JDK 17 install directory." -ForegroundColor Red
    exit 1
}

$javaHome = "$jdkRoot\$($jdkDir.Name)"
Write-Host "SUCCESS: Found JDK at: $javaHome" -ForegroundColor Green

# Set JAVA_HOME (machine-wide)
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, [System.EnvironmentVariableTarget]::Machine)
Write-Host "SUCCESS: JAVA_HOME set to: $javaHome" -ForegroundColor Green

# Update PATH only if it's not already in there
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$javaBin = "$javaHome\bin"
$newPath = "$javaBin;$currentPath"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
Write-Host "SUCCESS: Java added to system PATH." -ForegroundColor Green