
$port=$args[0]
$port2=$args[1]
if ($port -eq $null) {
  $port=22
}
if ($port2 -eq $null) {
  $port2=$port
}
write-host forwarding $port to $port2 on $(wsl hostname -I)
write-host netsh interface portproxy set v4tov4 listenport=8888 listenaddress=0.0.0.0 connectport=8888 connectaddress=$(wsl hostname -I)
netsh interface portproxy set v4tov4 listenport=8888 listenaddress=0.0.0.0 connectport=8888 connectaddress=$(wsl hostname -I)
