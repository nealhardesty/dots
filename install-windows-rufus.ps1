# PowerShell script to download and install the latest version of Rufus

Write-Host "Installing Rufus..." -ForegroundColor Green

# Use GitHub releases API to get latest version
$apiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$installDir = "C:\Program Files\Rufus"
$tempExe = Join-Path $env:TEMP "rufus.exe"
$destExe = Join-Path $installDir "rufus.exe"

try {
    # Get latest release info
    Write-Host "Getting latest Rufus version..." -ForegroundColor Yellow
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
    $releaseInfo = $webClient.DownloadString($apiUrl)
    $webClient.Dispose()
    
    # Parse JSON to get download URL
    $release = $releaseInfo | ConvertFrom-Json
    $downloadUrl = $release.assets | Where-Object { $_.name -like "rufus-*.exe" } | Select-Object -First 1 -ExpandProperty browser_download_url
    
    if (!$downloadUrl) {
        throw "Could not find Rufus download URL"
    }
    
    # Create installation directory
    if (!(Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    # Download Rufus
    Write-Host "Downloading Rufus..." -ForegroundColor Yellow
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
    $webClient.DownloadFile($downloadUrl, $tempExe)
    $webClient.Dispose()
    
    # Copy to installation directory
    Copy-Item -Path $tempExe -Destination $destExe -Force
    Remove-Item -Path $tempExe -Force
    
    Write-Host "Rufus installation completed successfully!" -ForegroundColor Green
    Write-Host "Rufus.exe is now available at: $destExe" -ForegroundColor Cyan
    
    # Launch Rufus automatically
    Write-Host "Launching Rufus..." -ForegroundColor Yellow
    Start-Process -FilePath $destExe
    
} catch {
    Write-Host "Error installing Rufus: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
