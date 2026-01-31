# Install Google Cloud CLI (gcloud)

$url = 'https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe'
$destination = "$env:TEMP\GoogleCloudSDKInstaller.exe"

Write-Host "Downloading Google Cloud SDK Installer..." -ForegroundColor Cyan
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $destination)

Write-Host "Installing Google Cloud SDK..." -ForegroundColor Cyan
Write-Host "Please follow the installer prompts." -ForegroundColor Yellow
Start-Process -FilePath $destination -Wait

Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "Run 'gcloud init' to initialize and authorize the CLI." -ForegroundColor Yellow
