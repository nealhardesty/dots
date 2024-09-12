$url='https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe'
$destination='c:\Windows\Temp\SteamSetup.exe'
Invoke-WebRequest -Uri $url -OutFile $destination

start-process $destination