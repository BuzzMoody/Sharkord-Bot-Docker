#!/bin/bash
set -e

# Default to your repository if none is specified
REPO_URL="${REPO_URL:-https://github.com/BuzzMoody/Sharkord-Bot.git}"

# Check if the core logic (Main.php) is missing
if [ ! -f "Main.php" ]; then
    echo "[DOCKER] Main.php not found. Fetching source from: $REPO_URL"
    
    # 1. Clone into a temporary folder
    git clone "$REPO_URL" /tmp/repo_clone
    
    # 2. Move everything (including hidden .git files) to the current dir
    cp -rn /tmp/repo_clone/. .
    
    # 3. Clean up the temp folder
    rm -rf /tmp/repo_clone
    echo "[DOCKER] Clone complete."
else
    echo "[DOCKER] Source code already exists. Skipping clone."
fi

# Ensure Composer dependencies are installed
if [ ! -d "vendor" ]; then
    echo "[DOCKER] Installing Composer dependencies..."
    composer install --no-interaction --optimize-autoloader
else
    echo "[DOCKER] Refreshing autoloader..."
    composer dump-autoload --optimize
fi

echo "[DOCKER] Starting Sharkord Bot..."
exec php Main.php