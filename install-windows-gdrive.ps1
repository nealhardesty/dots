

$url='https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$destination='c:\Windows\Temp\GoogleDriveSetup.exe'
$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($url, $destination)

Start-Process $destination