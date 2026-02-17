#!/bin/bash

# --- 1. UID/GID Mapping ---
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

if [ "$(id -u)" = '0' ]; then
    echo "Updating appuser to UID: $USER_ID and GID: $GROUP_ID..."
    
    # Alpine-specific user/group modification
    groupmod -g "$GROUP_ID" appgroup
    usermod -u "$USER_ID" -g "$GROUP_ID" appuser

    # Fix permissions for the app directory
    chown -R appuser:appgroup /app
fi

# --- 2. Check dependencies ---
cd /app

if [ ! -d "vendor" ]; then
    echo "First run detected. Installing Sharkord Framework..."
    
    if [ "$DEV" = "true" ]; then
        echo "DEV mode enabled. Installing dev branch..."
        # Swapped gosu for su-exec
        su-exec appuser composer require buzzmoody/sharkordbot:dev-dev --no-interaction --prefer-dist
    else
        # Swapped gosu for su-exec
        su-exec appuser composer require buzzmoody/sharkordbot --no-interaction --prefer-dist
    fi
else
    echo "Dependencies found. Checking for updates..."
    # Swapped gosu for su-exec
    su-exec appuser composer update --no-interaction
fi

# --- 4. Start the Bot ---
if [ -f "Main.php" ]; then
    echo "Starting Main.php as appuser..."
    # Swapped gosu for su-exec
    exec su-exec appuser php Main.php
else
    echo "Error: Main.php not found in /app."
    exit 1
fi