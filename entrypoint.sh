#!/bin/bash

# --- 1. UID/GID Mapping ---
# Default to 1000 if variables aren't provided
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

# Only attempt to modify users if we are currently root
if [ "$(id -u)" = '0' ]; then
    echo "Updating appuser to UID: $USER_ID and GID: $GROUP_ID..."
    
    # Update the group and user created in your Dockerfile
    groupmod -g "$GROUP_ID" appgroup
    usermod -u "$USER_ID" -g "$GROUP_ID" appuser

    # Ensure the /app directory is owned by our 'appuser'
    # This fixes permission issues with persistent volumes
    chown -R appuser:appgroup /app
fi

# --- 2. Configure Timezone ---
if [ -n "$TZ" ]; then
    echo "Setting timezone to $TZ..."
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
fi

# --- 3. Check dependencies ---
# Move into the app directory if not already there
cd /app

if [ ! -d "vendor" ]; then
    echo "First run detected. Installing Sharkord Framework..."
    
    if [ "$DEV" = "true" ]; then
        echo "DEV mode enabled. Installing dev branch..."
        gosu appuser composer require buzzmoody/sharkordbot:dev-dev --no-interaction --prefer-dist
    else
        gosu appuser composer require buzzmoody/sharkordbot --no-interaction --prefer-dist
    fi
else
    echo "Dependencies found. Checking for updates..."
    gosu appuser composer update --no-interaction
fi

# --- 4. Start the Bot ---
if [ -f "Main.php" ]; then
    echo "Starting Main.php as appuser..."
    # 'exec gosu' hands over the process to the appuser permanently
    exec gosu appuser php Main.php
else
    echo "Error: Main.php not found in /app."
    exit 1
fi