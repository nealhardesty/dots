$url='https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe'
$destination='c:\Windows\Temp\DockerDesktopInstaller.exe'
$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($url, $destination)

Start-Process $destination -Verb RunAs