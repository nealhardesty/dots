$url='https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe'
$destination='c:\Windows\Temp\python-3.10.11-amd64.exe'
$webClient = New-Object System.Net.webClient

$webClient.DownloadFile($url, $destination)

Start-Process $destination