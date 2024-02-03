#!/bin/bash

###############################################################################
# Script Name: install_rss_service.sh
# Description: This script creates a systemd service, downloads a Python script
#              from a GitHub repository, and configures it to run every 60 seconds.
# Author: Andres Cortes
# Date: January 31, 2024
# Version: 2.0 - Changes to the systemctl .service
#          1.0 - Initial
###############################################################################

# Define the log file
LOG_FILE="$(pwd)/install_rss_service.log"

# Function to display a message with a timestamp and save it to a log file
function log() {
    local log_message="$(date +'%Y-%m-%d %H:%M:%S') - $1"
    echo "$log_message"
    echo "$log_message" >> "$LOG_FILE"
}

# Parse the configuration file
CONFIG_FILE="./config_vars.ini"
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
    log "Getting GitHub script: $GITHUB_REPO"
    wget -O "$DIRECTORY_PATH/script.py" "$GITHUB_REPO"
    if [ $? -eq 0 ]; then
        log "Downloaded and moved GitHub script to $DIRECTORY_PATH"
    else
        log "Failed to download and move GitHub script"
        exit 1
    fi
else
    log "GITHUB_REPO not specified in the configuration file."
    exit 1
fi

# Create the config.ini file with the specified content
cat <<EOF > "$DIRECTORY_PATH/config.ini"
[Default]
rss_feed_url = $RSS_FEED_URL
webhook_url = $WEBHOOK_URL
rss_timezone = $RSS_TZ
local_timezone = America/Chicago
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
ExecStart=/usr/bin/python3 "/media/scripts/army/script.py"
Restart=always
User=root
RestartSec=60s  # Add a 60-second delay before restart
StartLimitIntervalSec=600s  # Set the interval to 10 minutes
StartLimitBurst=5  # Allow 5 restarts within the interval

[Install]
WantedBy=multi-user.target
EOF

# Add the chmod +x command here to make the script executable
chmod +x "$DIRECTORY_PATH/script.py"

if [ $? -eq 0 ]; then
    log "Created systemd service file: /etc/systemd/system/$SERVICE_FILE_NAME.service"
    log "Changed permissions of $DIRECTORY_PATH/script.py to make it executable"
else
    log "Failed to create systemd service file or change permissions of $DIRECTORY_PATH/script.py"
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
