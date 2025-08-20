# Windows PowerShell Upgrade Script
param(
    [switch]$Force,
    [switch]$Preview
)

# Set execution policy to allow script execution
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "PowerShell Upgrade Script" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

# Check current PowerShell version
$currentVersion = $PSVersionTable.PSVersion
Write-Host "Current PowerShell version: $currentVersion" -ForegroundColor Yellow

# Determine if we're running on Windows
if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne "Win32NT") {
    Write-Host "This script is designed for Windows only" -ForegroundColor Red
    exit 1
}

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "This script requires administrator privileges" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator" -ForegroundColor Yellow
    exit 1
}

# Function to get latest PowerShell version
function Get-LatestPowerShellVersion {
    param([switch]$Preview)
    
    try {
        $releasesUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases"
        $releases = Invoke-RestMethod -Uri $releasesUrl -Method Get
        
        if ($Preview) {
            $latestRelease = $releases | Where-Object { $_.prerelease -eq $true } | Select-Object -First 1
        } else {
            $latestRelease = $releases | Where-Object { $_.prerelease -eq $false } | Select-Object -First 1
        }
        
        return $latestRelease
    }
    catch {
        Write-Host "Error fetching latest PowerShell version: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Function to download and install PowerShell
function Install-PowerShell {
    param(
        [string]$Version,
        [string]$DownloadUrl,
        [string]$FileName
    )
    
    Write-Host "Downloading PowerShell $Version..." -ForegroundColor Green
    
    try {
        # Create temporary directory
        $tempDir = Join-Path $env:TEMP "PowerShellUpgrade"
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        # Download installer
        $installerPath = Join-Path $tempDir $FileName
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $installerPath
        
        Write-Host "Installing PowerShell $Version..." -ForegroundColor Green
        
        # Install PowerShell
        $process = Start-Process -FilePath $installerPath -ArgumentList "/quiet", "/norestart" -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host "PowerShell $Version installed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Installation failed with exit code: $($process.ExitCode)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error during installation: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        # Clean up temporary directory
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Get latest PowerShell version
Write-Host "Checking for latest PowerShell version..." -ForegroundColor Green
$latestRelease = Get-LatestPowerShellVersion -Preview:$Preview

if (-not $latestRelease) {
    Write-Host "Failed to get latest PowerShell version information" -ForegroundColor Red
    exit 1
}

$latestVersion = $latestRelease.tag_name.TrimStart('v')
Write-Host "Latest PowerShell version: $latestVersion" -ForegroundColor Yellow

# Check if upgrade is needed
if ($currentVersion -ge [Version]$latestVersion -and -not $Force) {
    Write-Host "PowerShell is already up to date (version $currentVersion)" -ForegroundColor Green
    exit 0
}

# Find the appropriate installer for Windows
$windowsAsset = $latestRelease.assets | Where-Object { 
    $_.name -like "PowerShell-*-win-x64.msi" -or 
    $_.name -like "PowerShell-*-win-x86.msi" 
} | Select-Object -First 1

if (-not $windowsAsset) {
    Write-Host "No Windows installer found for PowerShell $latestVersion" -ForegroundColor Red
    exit 1
}

Write-Host "Found installer: $($windowsAsset.name)" -ForegroundColor Green

# Install PowerShell
$success = Install-PowerShell -Version $latestVersion -DownloadUrl $windowsAsset.browser_download_url -FileName $windowsAsset.name

if ($success) {
    Write-Host "PowerShell upgrade completed successfully!" -ForegroundColor Green
    Write-Host "Please restart your PowerShell session to use the new version" -ForegroundColor Yellow
    
    # Show new version information
    Write-Host "`nTo verify the installation, restart PowerShell and run:" -ForegroundColor Cyan
    Write-Host "`$PSVersionTable.PSVersion" -ForegroundColor White
} else {
    Write-Host "PowerShell upgrade failed" -ForegroundColor Red
    exit 1
}
