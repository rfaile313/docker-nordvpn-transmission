#!/bin/bash

# Start D-Bus service
service dbus start
sleep 2

# Generate D-Bus machine ID
dbus-uuidgen --ensure
ln -sf /var/lib/dbus/machine-id /etc/machine-id

# Start NordVPN daemon directly
/usr/sbin/nordvpnd &
sleep 5

# Log in to NordVPN using your token
nordvpn login --token "$NORDVPN_TOKEN"

# Enable local network access
nordvpn set localnetworkaccess on

# Whitelist port 9091
nordvpn whitelist add port 9091

# Whitelist your local subnet
nordvpn whitelist add subnet "$LOCAL_NETWORK"

# Connect to NordVPN
nordvpn connect

# Modify Transmission settings
TRANSMISSION_SETTINGS="/config/settings.json"

# Wait for settings.json to be created if it doesn't exist
if [ ! -f "$TRANSMISSION_SETTINGS" ]; then
  echo "Waiting for Transmission settings file to be created..."
  transmission-daemon -g /config
  sleep 5
  pkill transmission-daemon
fi

# Update settings.json
if [ -f "$TRANSMISSION_SETTINGS" ]; then
  echo "Modifying Transmission settings..."

  # Disable rpc-whitelist
  sed -i 's/"rpc-whitelist-enabled":.*/"rpc-whitelist-enabled": false,/' "$TRANSMISSION_SETTINGS"

  # Alternatively, to add host IP to whitelist:
  # sed -i 's/"rpc-whitelist":.*/"rpc-whitelist": "127.0.0.1,192.168.88.*",/' "$TRANSMISSION_SETTINGS"
fi

# Start Transmission daemon with the specified config directory
transmission-daemon -g /config

# Keep the container running
tail -f /dev/null

