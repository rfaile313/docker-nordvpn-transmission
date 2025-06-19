FROM ubuntu:20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Preconfigure tzdata package
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends tzdata

# Install necessary packages
RUN apt-get install -y --no-install-recommends \
    wget \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    transmission-daemon \
    transmission-cli \
    openvpn \
    dbus \
    iputils-ping

# Add NordVPN repository and GPG key
RUN wget -qO - https://repo.nordvpn.com/gpg/nordvpn_public.asc | apt-key add - && \
    echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" > /etc/apt/sources.list.d/nordvpn.list

# Install NordVPN client
RUN apt-get update && \
    apt-get install -y nordvpn

# note(rudy) NordVPN v3.18+ moved the background service to a systemd-managed socket
# so pin this at 3.17
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nordvpn=3.17.4* && \
    echo "nordvpn hold" | dpkg --set-selections

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Generate machine ID for D-Bus
RUN dbus-uuidgen --ensure && \
    ln -sf /var/lib/dbus/machine-id /etc/machine-id

# Create necessary directories
RUN mkdir -p /var/lib/transmission-daemon/downloads && \
    mkdir -p /var/lib/transmission-daemon/incomplete && \
    mkdir -p /config

# Expose ports
EXPOSE 9091 51413

# Copy start script into the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set the entrypoint
ENTRYPOINT ["/start.sh"]

