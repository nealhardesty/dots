

$url='https://downloads.1password.com/win/1PasswordSetup-latest.exe'
$destination='c:\Windows\Temp\1PasswordSetup-latest.exe'
Invoke-WebRequest -Uri $url -OutFile $destination

Start-Process $destination