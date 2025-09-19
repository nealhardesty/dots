#!/bin/bash
#
#
# ufw --force reset
#
set -ex

curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cloudflare_ips_$$
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cloudflare_ips_$$

for ip in $(cat /tmp/cloudflare_ips_$$); do
  sudo ufw allow proto tcp from $ip to any port 80,443 comment 'Cloudflare' || echo did not add $ip
done

sudo ufw allow 22
sudo ufw allow 2222

sudo ufw deny 80
sudo ufw deny 443

sudo ufw enable
sudo ufw reload

sudo ufw status numbered
