#!/bin/bash

# Script to set up a VPN with adblock functionality
# This script will install OpenVPN, configure DNS sinkholing for adblocking,
# and set up iptables rules for traffic routing.

set -e  # Exit on any error

echo "Setting up VPN with adblock functionality..."

# Update system packages
apt-get update

# Install required packages
apt-get install -y openvpn easy-rsa dnsmasq curl wget iptables

# Create easy-rsa PKI directory
make-cadir /etc/openvpn/easy-rsa

# Configure DNSMasq for adblocking
cat > /etc/dnsmasq.conf << EOF
# Basic DNSMasq configuration
domain-needed
bogus-priv
no-resolv
server=8.8.8.8
server=8.8.4.4
conf-file=/etc/dnsmasq-blocklists.conf
cache-size=1000
neg-ttl=60
EOF

# Create blocklists configuration
touch /etc/dnsmasq-blocklists.conf

# Download adblock lists and convert to DNS sinkhole format
echo "Downloading adblock lists..."
mkdir -p /etc/openvpn/adblock/

# Download common adblock lists
wget -q -O /tmp/hosts-adaway https://adaway.org/hosts.txt
wget -q -O /tmp/hosts-mvps https://winhelp2002.mvps.org/hosts.txt
wget -q -O /tmp/hosts-someonewhocares https://someonewhocares.org/hosts/zero/hosts
wget -q -O /tmp/hosts-disconnect https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt

# Process the lists and convert to dnsmasq format
{
    # Process AdAway list
    grep '^127.0.0.1' /tmp/hosts-adaway | sed 's/127.0.0.1/address=\//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]/\/0.0.0.0/' | grep -v 'localhost'
    
    # Process MVPS list
    grep '^127.0.0.1' /tmp/hosts-mvps | sed 's/127.0.0.1/address=\//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]/\/0.0.0.0/' | grep -v 'localhost'
    
    # Process Someonewhocares list
    grep '^127.0.0.1' /tmp/hosts-someonewhocares | sed 's/127.0.0.1/address=\//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]/\/0.0.0.0/' | grep -v 'localhost'
    
    # Process Disconnect list
    sed 's/^/address=\//' /tmp/hosts-disconnect | sed 's/[[:space:]]/\/0.0.0.0/' | sed 's/^/address=\//' | sed 's/\/address=/address=/'
} > /etc/dnsmasq-blocklists.conf

# Clean up temporary files
rm -f /tmp/hosts-*

echo "Adblock lists configured."

# Create basic OpenVPN server configuration
cat > /etc/openvpn/server.conf << EOF
port 1194
proto udp
dev tun
ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 10.8.0.1"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
explicit-exit-notify 1
EOF

# Enable IP forwarding
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

# Set up iptables rules for NAT and adblocking
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# Start services
systemctl enable openvpn@server
systemctl start openvpn@server
systemctl enable dnsmasq
systemctl start dnsmasq

echo "VPN with adblock functionality has been set up!"
echo "To generate client certificates, run: /etc/openvpn/easy-rsa/easyrsa build-client-full [client-name]"