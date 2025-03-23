#!/usr/bin/env bash

# Change VPN connection in the container
if docker exec -it transmission-vpn nordvpn c; then
    echo "VPN connection changed successfully."
else
    echo "Failed to change VPN connection." >&2
    exit 1
fi

