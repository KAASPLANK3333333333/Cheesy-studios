# VPN with Adblock Functionality

This setup provides a complete VPN solution with integrated ad-blocking capabilities. The system routes traffic through a VPN while simultaneously blocking ads and trackers.

## Components

1. **VPN Server**: OpenVPN-based VPN server
2. **DNS Filtering**: Adblock functionality through DNS sinkhole
3. **Automatic Updates**: Regular updates to adblock lists

## Features

- Secure VPN connection
- Ad blocking at DNS level
- Customizable block lists
- Automatic list updates
- Traffic encryption

## Requirements

- Linux server with root access
- OpenVPN
- DNS server (we'll use Unbound or Dnsmasq)
- iptables for traffic routing