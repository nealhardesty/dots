
#$url='https://github.com/rustdesk/rustdesk/releases/download/1.3.7/rustdesk-1.3.7-x86_64.exe'
#$destination='c:\Windows\Temp\rustdesk.exe'
$url='https://github.com/rustdesk/rustdesk/releases/download/1.3.7/rustdesk-1.3.7-x86_64.msi'
$destination='c:\Windows\Temp\rustdesk.msi'
$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($url, $destination)

Start-Process $destination