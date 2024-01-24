# https://gist.github.com/manoj-choudhari-git/fa3bda9c51b095ef00e91cc33dc2a41a

# STEP 1: Enable Virtual Machine Platform feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# STEP 2: Enable WSL feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# STEP 3: Restart Win 10 Machine
write-host "You should install the wsl2 kernel via 'https://aka.ms/wsl2kernel'"
start-process "https://aka.ms/wsl2kernel"
start-process "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
write-host ""
write-host "You must then restart windows..."
restart-computer -Confirm

# STEP 4: To set the WSL default version to 2.
# Any distribution installed after this, would run on WSL 2
#wsl --set-default-version 2