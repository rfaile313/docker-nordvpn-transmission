#!/usr/bin/env bash

# Get the container IP address
container_ip=$(docker exec transmission-vpn curl -s ifconfig.me)

# Get the host machine IP address
host_ip=$(curl -s ifconfig.me)

# Compare the two IPs
if [ "$container_ip" == "$host_ip" ]; then
    # Output in red (VPN is not working)
    echo -e "\033[31mVPN NOT WORKING: Both IPs are the same ($container_ip)\033[0m"
else
    # Output in green (VPN is working)
    echo -e "\033[32mVPN WORKING: Container IP ($container_ip) is different from Host IP ($host_ip)\033[0m"
fi
