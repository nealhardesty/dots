$url="https://download.sysinternals.com/files/RDCMan.zip"
$destination='c:\Windows\Temp\RDCMan.zip'
Invoke-WebRequest -Uri $url -OutFile $destination
# unzip the file
Add-Type -AssemblyName System.IO.Compression.FileSystem 
$zipPath = $destination
# extract into mhome directory
$extractPath = "$env:USERPROFILE\Downloads\RDCMan"
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)