$url='https://go.dev/dl/go1.24.0.windows-amd64.msi'
$destination='c:\Windows\Temp\golanginstall.msi'
$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($url, $destination)

Start-Process msiexec.exe -ArgumentList "/i", $destination -Verb RunAs