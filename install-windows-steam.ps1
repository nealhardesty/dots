$url='https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe'
$destination='c:\Windows\Temp\SteamSetup.exe'
$webClient = New-Object System.Net.webClient
$webClient.DownloadFile($url, $destination)

Start-Process $destination