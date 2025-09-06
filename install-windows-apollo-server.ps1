$apolloResponse = Invoke-RestMethod -Uri 'https://api.github.com/repos/ClassicOldSong/Apollo/releases/latest'
$apolloAsset = $apolloResponse.assets | Where-Object { $_.name -like '*.exe' }
$apolloUrl = $apolloAsset.browser_download_url
$apolloDestination = "$env:USERPROFILE\Downloads\" + $apolloAsset.name

$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($apolloUrl, $apolloDestination)
Start-Process $apolloDestination -Verb RunAs
