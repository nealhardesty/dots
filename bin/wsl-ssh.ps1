$Ports = (22,2222)

# Find the first WSL ip address
wsl -- ip -o -4 -json addr list eth0 |convertfrom-json | %{ $_.addr_info.local } | ?{ $_ } | set-variable -name "WSL"

$found = $WSL -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
if (-not $found) {
  echo "WSL2 ip address cannot be found. Must terminate.";
  exit;
}

echo "Forwarding to $WSL"

echo "Starting SSH"
wsl -- systemctl start sshd

# Remove and Create NetFireWallRule
Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock';
New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $Ports -Action Allow -Protocol TCP;
New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $Ports -Action Allow -Protocol TCP;

# Add each port into portproxy
$Addr = "0.0.0.0"
Foreach ($Port in $Ports) {
    echo "netsh interface portproxy delete v4tov4 listenaddress=$Addr listenport=$Port | Out-Null";
    iex "netsh interface portproxy delete v4tov4 listenaddress=$Addr listenport=$Port | Out-Null";
    if ($Args[0] -ne "delete") {
        echo "netsh interface portproxy add v4tov4 listenaddress=$Addr listenport=$Port connectaddress=$WSL connectport=$Port | Out-Null";
        iex "netsh interface portproxy add v4tov4 listenaddress=$Addr listenport=$Port connectaddress=$WSL connectport=$Port | Out-Null";
    }
}

# Display all portproxy information
netsh interface portproxy show v4tov4;