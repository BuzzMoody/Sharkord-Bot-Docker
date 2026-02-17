#!/bin/bash

# 1. Configure Timezone
if [ -n "$TZ" ]; then
    echo "Setting timezone to $TZ..."
    cp /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
fi

# 2. Check dependencies
# Since the volume is persistent, we check if we already installed the bot
if [ ! -d "vendor" ]; then
    echo "First run detected. Installing Sharkord Framework..."
    composer require buzzmoody/sharkord --no-interaction --prefer-dist
else
    echo "Dependencies found. Checking for updates..."
    # Optional: Uncomment the next line if you want to auto-update every time
    composer update --no-interaction
fi

# 3. Start the Bot
if [ -f "Main.php" ]; then
    echo "Starting Main.php..."
    exec php Main.php
else
    echo "Error: Main.php not found in /app."
    echo "Ensure you are running this from the correct folder containing Main.php"
    exit 1
fi