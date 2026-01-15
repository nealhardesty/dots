<#
.SYNOPSIS
    Automatically forwards a Windows port to the current WSL2 instance IP
    and opens the Windows Firewall for external access.
#>

param (
    [int]$Port = 8080,      # The port you want to forward
    [string]$Distro = ""    # Optional: Specify a distro (e.g., "Ubuntu"), otherwise uses default
)

# 1. Ensure the script is running as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Port $Port -Distro `"$Distro`"" -Verb RunAs
    Exit
}

Write-Host "--- WSL2 Port Forwarder ---" -ForegroundColor Cyan

# 2. Get the IP Address of the WSL2 instance
Write-Host "Fetching WSL2 IP Address..." -NoNewline
try {
    if ($Distro) {
        $wsl_ip = (wsl -d $Distro hostname -I).Trim().Split(" ")[0]
    } else {
        $wsl_ip = (wsl hostname -I).Trim().Split(" ")[0]
    }

    if ([string]::IsNullOrWhiteSpace($wsl_ip)) {
        throw "Could not retrieve IP. Is WSL running?"
    }
    Write-Host " Found: $wsl_ip" -ForegroundColor Green
}
catch {
    Write-Error "Failed to get WSL IP. Error: $_"
    Pause
    Exit
}

# 3. Clean up old rules for this port
Write-Host "Resetting old rules for port $Port..." -ForegroundColor Gray
netsh interface portproxy delete v4tov4 listenport=$Port listenaddress=0.0.0.0 | Out-Null

# 4. Create the Bridge (Port Proxy)
Write-Host "Forwarding Windows 0.0.0.0:$Port -> WSL ${wsl_ip}:$Port ..." -NoNewline
try {
    netsh interface portproxy add v4tov4 listenport=$Port listenaddress=0.0.0.0 connectport=$Port connectaddress=$wsl_ip
    Write-Host " Done." -ForegroundColor Green
}
catch {
    Write-Error "Failed to add portproxy. Error: $_"
    Pause
    Exit
}

# 5. Open Windows Firewall (Allow Inbound)
$RuleName = "WSL2_Bridge_$Port"
Write-Host "Configuring Firewall Rule '$RuleName'..." -NoNewline

# Check if rule exists, remove it to update it cleanly
Remove-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue

try {
    New-NetFirewallRule -DisplayName $RuleName `
                        -Direction Inbound `
                        -Action Allow `
                        -Protocol TCP `
                        -LocalPort $Port `
                        -Profile Any `
                        | Out-Null
    Write-Host " Allowed." -ForegroundColor Green
}
catch {
    Write-Host " Warning: Could not set Firewall rule (might already exist or permission denied)." -ForegroundColor Yellow
}

Write-Host "`nSuccess! Your WSL2 server is now accessible externally." -ForegroundColor Cyan
Write-Host "Local Access:    http://localhost:$Port"
Write-Host "External Access: http://$((Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Wi-Fi','Ethernet' | Select-Object -ExpandProperty IPAddress | Select-Object -First 1)):$Port"