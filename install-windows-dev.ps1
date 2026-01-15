Set-ExecutionPolicy Bypass -Scope Process -Force

net.exe stop wsearch
sc.exe config wsearch start=disabled

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation

choco install -y googlechrome 
choco install -y firefox 
choco install -y sumatrapdf 
choco install -y 7zip 
choco install -y sharpkeys
choco install -y paint.net
choco install -y irfanview 
choco install -y inkscape 
choco install -y visualstudiocode 
choco install -y vlc 

#choco install -y battle.net 
#choco install -y spotify 
#choco install -y dropbox
#choco install -y microsoft-windows-terminal
choco install -y autohotkey
choco install -y autologon
choco install -y python311
#choco install -y wsl-ubuntu-2204

#choco install -y flow-launcher

choco install -y make
choco install -y mingw


# swap capslock to escape
Invoke-Expression "cmd.exe /C start capsToEscape.reg"



# https://docs.microsoft.com/en-us/windows/wsl/install-win10

# windows subsystem
#dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# wsl 2
#dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
#wsl --set-default-version 2

#Invoke-Expression "cmd.exe /C start https://aka.ms/wslstore"


#copy settings.json C:\Users\neal\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
