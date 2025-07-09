
$url='https://downloads.1password.com/win/1PasswordSetup-latest.exe'
$destination='c:\Windows\Temp\1PasswordSetup-latest.exe'

$webClient = New-Object System.Net.webClient
$webClient.DownloadFile($url, $destination)

Start-Process $destination