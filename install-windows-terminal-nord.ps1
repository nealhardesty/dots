$installPath = "$Env:LocalAppData\Microsoft\Windows Terminal\Fragments\nord"

if (!(Test-Path $installPath)) {
  New-Item -Type Directory -Path $installPath
}

Copy-Item -Path nord.json -Destination $installPath