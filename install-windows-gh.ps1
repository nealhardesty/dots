# Install GitHub CLI for Windows
param(
    [switch]$Force
)

# Set execution policy to allow script execution
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "GitHub CLI Installation Script" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

# Check if GitHub CLI is already installed
$ghVersion = gh --version 2>$null
if ($ghVersion -and -not $Force) {
    Write-Host "GitHub CLI is already installed:" -ForegroundColor Yellow
    Write-Host $ghVersion -ForegroundColor Green
    Write-Host "Use -Force to reinstall" -ForegroundColor Yellow
    exit 0
}

# Function to get latest GitHub CLI version
function Get-LatestGitHubCLIVersion {
    try {
        $releasesUrl = "https://api.github.com/repos/cli/cli/releases/latest"
        $latestRelease = Invoke-RestMethod -Uri $releasesUrl -Method Get
        
        # Find Windows MSI installer
        $windowsAsset = $latestRelease.assets | Where-Object { 
            $_.name -like "*windows_amd64.msi" 
        } | Select-Object -First 1
        
        if ($windowsAsset) {
            return @{
                Version = $latestRelease.tag_name.TrimStart('v')
                DownloadUrl = $windowsAsset.browser_download_url
                FileName = $windowsAsset.name
            }
        } else {
            throw "Windows MSI installer not found in latest release"
        }
    }
    catch {
        Write-Host "Error fetching latest GitHub CLI version: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Function to download and install GitHub CLI
function Install-GitHubCLI {
    param(
        [string]$Version,
        [string]$DownloadUrl,
        [string]$FileName
    )
    
    Write-Host "Downloading GitHub CLI $Version..." -ForegroundColor Green
    
    try {
        # Create temporary directory
        $tempDir = Join-Path $env:TEMP "GitHubCLI"
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        # Download installer
        $installerPath = Join-Path $tempDir $FileName
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $installerPath
        
        Write-Host "Installing GitHub CLI $Version..." -ForegroundColor Green
        
        # Install GitHub CLI silently
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $installerPath, "/quiet", "/norestart" -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host "GitHub CLI $Version installed successfully" -ForegroundColor Green
            
            # Refresh environment variables
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            
            # Verify installation
            Start-Sleep -Seconds 2
            $newVersion = gh --version 2>$null
            if ($newVersion) {
                Write-Host "Installation verified:" -ForegroundColor Green
                Write-Host $newVersion -ForegroundColor Green
            }
            
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

# Get latest GitHub CLI version
Write-Host "Fetching latest GitHub CLI version..." -ForegroundColor Yellow
$latestVersion = Get-LatestGitHubCLIVersion

if (-not $latestVersion) {
    Write-Host "Failed to get latest version information" -ForegroundColor Red
    exit 1
}

Write-Host "Latest version: $($latestVersion.Version)" -ForegroundColor Green

# Install GitHub CLI
$success = Install-GitHubCLI -Version $latestVersion.Version -DownloadUrl $latestVersion.DownloadUrl -FileName $latestVersion.FileName

if ($success) {
    Write-Host "`nGitHub CLI installation completed successfully!" -ForegroundColor Green
    Write-Host "You can now use 'gh' commands in your terminal" -ForegroundColor Yellow
    Write-Host "To authenticate with GitHub, run: gh auth login" -ForegroundColor Yellow
} else {
    Write-Host "`nGitHub CLI installation failed" -ForegroundColor Red
    exit 1
}
