# PowerShell script to download and install Autologon from Microsoft Sysinternals

Write-Host "Installing Autologon..." -ForegroundColor Green

# Create a temporary directory for download
$tempDir = Join-Path $env:TEMP "autologon"
if (!(Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
}

# Download URL for Autologon (using Sysinternals Live)
$downloadUrl = "https://live.sysinternals.com/Autologon.exe"
$tempExe = Join-Path $tempDir "Autologon.exe"

try {
    # Download Autologon using WebClient
    Write-Host "Downloading Autologon..." -ForegroundColor Yellow
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($downloadUrl, $tempExe)
    $webClient.Dispose()
    
    # Create a directory in Program Files for Autologon
    $installDir = "C:\Program Files\Autologon"
    if (!(Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    # Copy the executable to Program Files
    $destExe = Join-Path $installDir "Autologon.exe"
    Copy-Item -Path $tempExe -Destination $destExe -Force
    
    # Clean up temporary files
    Remove-Item -Path $tempDir -Recurse -Force
    
    Write-Host "Autologon installation completed successfully!" -ForegroundColor Green
    Write-Host "Autologon.exe is now available at: $destExe" -ForegroundColor Cyan
    
    # Launch Autologon automatically
    Write-Host "Launching Autologon..." -ForegroundColor Yellow
    Start-Process -FilePath $destExe
    
} catch {
    Write-Host "Error installing Autologon: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
