
$destination='c:\Windows\Temp\battle.net.installer.exe'
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36"
Invoke-WebRequest -OutFile $destination -UseBasicParsing -Uri "https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe" `
-WebSession $session `
-Headers @{
"DNT"="1"
  "Upgrade-Insecure-Requests"="1"
  "sec-ch-ua"="`"Chromium`";v=`"128`", `"Not;A=Brand`";v=`"24`", `"Google Chrome`";v=`"128`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
}

Start-Process $destination