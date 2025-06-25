$url='https://joytokey.net/download/JoyToKeySetup_en.exe'
$destination='c:\Windows\Temp\JoyToKeySetup_en.exe'
$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($url, $destination)

Start-Process $destination