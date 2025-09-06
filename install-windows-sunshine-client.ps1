$moonlightResponse = Invoke-RestMethod -Uri 'https://api.github.com/repos/moonlight-stream/moonlight-qt/releases/latest'
$moonlightAsset = $moonlightResponse.assets | Where-Object { $_.name -like 'MoonlightSetup-*.exe' }

if ($moonlightAsset) {
    $moonlightUrl = $moonlightAsset.browser_download_url
    $moonlightDestination = "$env:USERPROFILE\Downloads\" + $moonlightAsset.name
    
    Write-Host "Downloading Moonlight client from: $moonlightUrl"
    Write-Host "Saving to: $moonlightDestination"
    
    $webClient = New-Object System.Net.webClient
    $webClient.DownloadFile($moonlightUrl, $moonlightDestination)
    
    Write-Host "Starting Moonlight installer..."
    Start-Process -FilePath $moonlightDestination -Verb RunAs
} else {
    Write-Error "No Moonlight Windows installer found in the latest release"
}
