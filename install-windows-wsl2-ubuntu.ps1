# https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

write-host "You should install the wsl2 kernel via 'https://aka.ms/wsl2kernel'"
(New-Object Net.WebClient).DownloadFile("https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi","C:\Windows\Temp\wsl_update_x64.msi")
start-process c:\Windows\Temp\wsl_update_x64.msi
#start-process "https://aka.ms/wsl2kernel"
#start-process "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"

wsl --set-default-version 2
wsl --list --online

wsl --install -d Ubuntu-22.04