# Docker NordVPN Transmission Container

A Docker container that runs Transmission torrent client through NordVPN, isolating your docker container's activities from your host machine's IP address.

## Features

- Runs Transmission torrent client inside a container with NordVPN
- Automatically connects to NordVPN before starting Transmission
- Enables access from your local network to the Transmission web interface
- Persists downloads, incomplete files, and configuration between container restarts

## Requirements

- Docker and Docker Compose installed on your system
- A valid NordVPN subscription and token

## Setup Instructions

### 1. Clone this repository

```bash
git clone https://github.com/rfaile313/docker-nordvpn-transmission.git
cd docker-nordvpn-transmission
```

### 2. Get your NordVPN token

1. Log in to your NordVPN account at https://my.nordaccount.com/dashboard/
2. Navigate to the "NordVPN API" section
3. Generate a new token (or use an existing one)

### 3. Configure docker-compose.yml

Edit the `docker-compose.yml` file:

1. Replace `your_nordvpn_token_goes_here` with your actual NordVPN token
2. Update `LOCAL_NETWORK` with your actual LAN subnet (e.g., "192.168.1.0/24")
3. Update the volume paths to match your system:
   ```yaml
   volumes:
     - /path/on/your/system/downloads:/var/lib/transmission/downloads
     - /path/on/your/system/incomplete:/var/lib/transmission/incomplete
     - /path/on/your/system/info:/var/lib/transmission-daemon/info
     - /path/on/your/system/config:/config
   ```

### 4. Update Transmission settings

Before starting the container, update the RPC password in `config/settings.json`:

1. Find the line with `"rpc-password"` (currently set to a placeholder)
2. Replace it with a new password of your choice
3. You may also want to enable authentication by setting `"rpc-authentication-required": true`

Note: The config directory comes with basic settings only. The container will generate any missing files when it first runs.

## Running the Container

Start the container with:

```bash
docker-compose up -d
```

Access the Transmission web interface at:
```
http://your-server-ip:9091/transmission/web/
```

## Security Considerations

- The NordVPN token in `docker-compose.yml` grants access to your VPN account. Never publish this file without removing the token.
- Consider enabling authentication for the Transmission web interface by setting `"rpc-authentication-required": true` in `settings.json`.
- Review the whitelist settings in both `settings.json` and `start.sh` to ensure only your network has access.

## Helper Scripts

This repository includes two useful helper scripts:

### Check VPN Status

Verify that your VPN is working correctly by comparing the container's IP address with your host machine's IP:

```bash
chmod +x checkvpn.sh
./checkvpn.sh
```

If working correctly, you'll see a message showing different IPs for your container and host.

### Change VPN Connection

Reconnect to a different NordVPN server while the container is running:

```bash
chmod +x changecontainervpn.sh
./changecontainervpn.sh
```

This will disconnect from the current server and connect to a new one.

## Troubleshooting

- Check container logs with `docker logs transmission-vpn`
- Verify NordVPN connection status with `docker exec transmission-vpn nordvpn status`
- If the container exits unexpectedly, ensure your NordVPN token is valid

