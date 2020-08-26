Set-ExecutionPolicy Bypass -Scope Process -Force

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y firefox 
choco install -y sumatrapdf 
choco install -y 7zip 
choco install -y sharpkeys
choco install -y paint.net 
choco install -y irfanview 
choco install -y inkscape 
choco install -y visualstudiocode 
choco install -y vlc 
choco install -y chrome 
#choco install -y battle.net 
#choco install -y spotify 
#choco install -y dropbox
choco install -y microsoft-windows-terminal
choco install -y powertoys
choco install -y lxrunoffline


# swap capslock to escape
Invoke-Expression "cmd.exe /C start capsToEscape.reg"



# https://docs.microsoft.com/en-us/windows/wsl/install-win10

# windows subsystem
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# wsl 2
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2

Invoke-Expression "cmd.exe /C start https://aka.ms/wslstore"
