#  set-executionpolicy unrestricted -scope process -force
#
#
# https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
# C:\Windows\System32\OpenSSH\sshd.exe


Get-WindowsCapability -Online |? Name -Like 'OpenSSH*' |ForEach-Object { Add-WindowsCapability -Online -Name $_.Name }

<#
 $FilePath = <Path to File>

(Get-Content ($FilePath + "\Host400.txt")) | Foreach-Object {$_ -replace '^workstationID.$', ("WorkstationID=" + $computerName)} | Set-Content  ($Filepath + "\Host400.txt")

#>

# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

#New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


echo SSHD Config Location: $Env:ProgramData\sshd_config
