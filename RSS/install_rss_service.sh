#!/bin/bash

###############################################################################
# Script Name: install_rss_service.sh
# Description: This script creates a systemd service, downloads a Python script
#              from a GitHub repository, and configures it to run every 60 seconds.
# Author: Andres Cortes
# Date: January 31, 2024
# Version: 1.0
###############################################################################



# Function to display a message with a timestamp
function log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Parse the configuration file
CONFIG_FILE="./config.ini"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    log "Configuration file $CONFIG_FILE not found."
    exit 1
fi

# Create the directory specified in DIRECTORY_PATH if it doesn't exist
mkdir -p "$DIRECTORY_PATH"
if [ $? -eq 0 ]; then
    log "Created directory $DIRECTORY_PATH"
else
    log "Failed to create directory $DIRECTORY_PATH"
    exit 1
fi

# Set permissions on the directory to 777
chmod 777 "$DIRECTORY_PATH"
if [ $? -eq 0 ]; then
    log "Set permissions on $DIRECTORY_PATH to 777"
else
    log "Failed to set permissions on $DIRECTORY_PATH"
    exit 1
fi

# Clone the GitHub repository specified in GITHUB_REPO
if [ -n "$GITHUB_REPO" ]; then
    log "Cloning GitHub repository: $GITHUB_REPO"
    wget "$GITHUB_REPO" "$DIRECTORY_PATH"
    if [ $? -ne 0 ]; then
        log "Failed to clone GitHub repository"
        exit 1
    fi
else
    log "GITHUB_REPO not specified in the configuration file."
    exit 1
fi

# Create the config.ini file with the specified content
cat <<EOF > "$DIRECTORY_PATH/config.ini"
[webhook]
webhook_url = $WEBHOOK_URL
[feed]
rss_feed_url = $RSS_FEED_URL
EOF

if [ $? -eq 0 ]; then
    log "Created $DIRECTORY_PATH/config.ini"
else
    log "Failed to create $DIRECTORY_PATH/config.ini"
    exit 1
fi

# Create the systemd service file
cat <<EOF > "/etc/systemd/system/$SERVICE_FILE_NAME.service"
[Unit]
Description=$SERVICE_DESCRIPTION

[Service]
ExecStart=/usr/bin/python3 $PYTHON_SCRIPT_PATH
Restart=always
User=$USERNAME

[Install]
WantedBy=multi-user.target
EOF

if [ $? -eq 0 ]; then
    log "Created systemd service file: /etc/systemd/system/$SERVICE_FILE_NAME.service"
else
    log "Failed to create systemd service file"
    exit 1
fi

# Create the systemd timer unit
cat <<EOF > "/etc/systemd/system/$SERVICE_FILE_NAME.timer"
[Unit]
Description=$SERVICE_DESCRIPTION Timer

[Timer]
OnBootSec=60s
OnUnitActiveSec=60s

[Install]
WantedBy=timers.target
EOF

if [ $? -eq 0 ]; then
    log "Created systemd timer unit: /etc/systemd/system/$SERVICE_FILE_NAME.timer"
else
    log "Failed to create systemd timer unit"
    exit 1
fi

# Reload the systemd daemon to pick up the new service and timer files
systemctl daemon-reload
if [ $? -eq 0 ]; then
    log "Reloaded systemd daemon"
else
    log "Failed to reload systemd daemon"
    exit 1
fi

# Enable and start the timer
systemctl enable "$SERVICE_FILE_NAME.timer"
systemctl start "$SERVICE_FILE_NAME.timer"

log "Script execution completed successfully"
