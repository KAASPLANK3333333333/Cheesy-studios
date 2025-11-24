#!/bin/bash

# Script to update adblock lists for the VPN with adblock functionality

set -e

echo "Updating adblock lists..."

# Download latest adblock lists
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

# Restart dnsmasq to apply new blocklists
systemctl restart dnsmasq

echo "Adblock lists updated successfully!"