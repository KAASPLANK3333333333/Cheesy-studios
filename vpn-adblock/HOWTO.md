# How to Use the VPN with Adblock

## Server Setup

1. Run the setup script:
   ```bash
   sudo /workspace/vpn-adblock/scripts/setup-vpn-adblock.sh
   ```

2. Generate client certificates:
   ```bash
   cd /etc/openvpn/easy-rsa
   ./easyrsa build-client-full [client-name]
   ```

3. Retrieve the client certificate files:
   - `/etc/openvpn/easy-rsa/pki/ca.crt`
   - `/etc/openvpn/easy-rsa/pki/issued/[client-name].crt`
   - `/etc/openvpn/easy-rsa/pki/private/[client-name].key`

## Client Configuration

1. Combine the client configuration with certificates:
   ```bash
   cat > client-config.ovpn << EOF
   client
   dev tun
   proto udp
   remote [YOUR_SERVER_IP] 1194
   resolv-retry infinite
   nobind
   persist-key
   persist-tun
   remote-cert-tls server
   cipher AES-256-CBC
   verb 3
   auth-nocache

   <ca>
   [Contents of /etc/openvpn/easy-rsa/pki/ca.crt]
   </ca>

   <cert>
   [Contents of /etc/openvpn/easy-rsa/pki/issued/[client-name].crt]
   </cert>

   <key>
   [Contents of /etc/openvpn/easy-rsa/pki/private/[client-name].key]
   </key>
   EOF
   ```

2. Connect using OpenVPN client:
   ```bash
   openvpn --config client-config.ovpn
   ```

## Updating Adblock Lists

Run the update script periodically to refresh the adblock lists:
```bash
sudo /workspace/vpn-adblock/scripts/update-blocklists.sh
```

Or set up a cron job to update automatically:
```bash
# Add to crontab to update weekly
0 2 * * 0 /workspace/vpn-adblock/scripts/update-blocklists.sh
```

## How It Works

1. When clients connect to the VPN, they are assigned an IP in the 10.8.0.x range
2. All DNS requests from clients are directed to the VPN server (10.8.0.1)
3. The DNSMasq service on the server processes these requests
4. If a requested domain is in the blocklist, it's redirected to 0.0.0.0 (blocking it)
5. Otherwise, the request is forwarded to upstream DNS servers (8.8.8.8, 8.8.4.4)

This setup provides both privacy through VPN encryption and ad blocking at the DNS level.