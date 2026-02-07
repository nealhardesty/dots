#!/bin/sh
#
# To make localhost:3390 work, also enable route_localnet (has security implications):
#   sudo sysctl -w net.ipv4.conf.all.route_localnet=1
#
set -ex

GUEST_IP="192.168.122.50"
GUEST_PORT="3389"
HOST_PORT="3390"

if [ "${1}" = 'stop' ]; then
  echo Removing forwarding ${HOST_PORT} to ${GUEST_IP}:${GUEST_PORT}
  sudo iptables -t nat -D PREROUTING -p tcp --dport ${HOST_PORT} -j DNAT --to ${GUEST_IP}:${GUEST_PORT}
  sudo iptables -t nat -D OUTPUT -p tcp --dport ${HOST_PORT} -j DNAT --to ${GUEST_IP}:${GUEST_PORT}
  sudo iptables -t nat -D POSTROUTING -d ${GUEST_IP} -p tcp --dport ${GUEST_PORT} -j MASQUERADE
  sudo iptables -D FORWARD -d ${GUEST_IP}/32 -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport ${GUEST_PORT} -j ACCEPT
else
  echo Forwarding ${HOST_PORT} to ${GUEST_IP}:${GUEST_PORT}
  sudo sysctl -w net.ipv4.ip_forward=1
  sudo iptables -t nat -I PREROUTING -p tcp --dport ${HOST_PORT} -j DNAT --to ${GUEST_IP}:${GUEST_PORT}
  sudo iptables -t nat -I OUTPUT -p tcp --dport ${HOST_PORT} -j DNAT --to ${GUEST_IP}:${GUEST_PORT}
  sudo iptables -t nat -I POSTROUTING -d ${GUEST_IP} -p tcp --dport ${GUEST_PORT} -j MASQUERADE
  sudo iptables -I FORWARD -d ${GUEST_IP}/32 -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport ${GUEST_PORT} -j ACCEPT
fi
sudo iptables -t nat -L -n -v
