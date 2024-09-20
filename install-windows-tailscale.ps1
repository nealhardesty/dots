
$destination='c:\Windows\Temp\tailscale-setup-latest.exe'

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
Invoke-WebRequest -OutFile $destination -UseBasicParsing -Uri "https://pkgs.tailscale.com/stable/tailscale-setup-latest.exe" `
-WebSession $session `
-Headers @{
"authority"="pkgs.tailscale.com"
  "method"="GET"
  "path"="/stable/tailscale-setup-latest.exe"
  "scheme"="https"
  "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
  "accept-encoding"="gzip, deflate, br, zstd"
  "accept-language"="en-US,en;q=0.9,ja-JP;q=0.8,ja;q=0.7"
  "dnt"="1"
  "priority"="u=0, i"
  "referer"="https://tailscale.com/"
  "sec-ch-ua"="`"Google Chrome`";v=`"129`", `"Not=A?Brand`";v=`"8`", `"Chromium`";v=`"129`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "sec-fetch-dest"="document"
  "sec-fetch-mode"="navigate"
  "sec-fetch-site"="same-site"
  "sec-fetch-user"="?1"
  "upgrade-insecure-requests"="1"
}

Start-Process $destination