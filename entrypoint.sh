#!/bin/bash
set -e

# Default to your repository if none is specified in environment variables
REPO_URL="${REPO_URL:-https://github.com/BuzzMoody/Sharkord-Bot.git}"

# Check if the directory is empty or doesn't contain the core logic
if [ ! -f "Main.php" ]; then
    echo "[DOCKER] Target directory is empty. Cloning repository: $REPO_URL"
    # Clone into a temporary folder to avoid "directory not empty" errors, then move
    git clone "$REPO_URL" .
else
    echo "[DOCKER] Source code already exists. Skipping clone."
fi

# Ensure Composer dependencies are installed so namespaces work
if [ ! -d "vendor" ]; then
    echo "[DOCKER] Installing Composer dependencies..."
    composer install --no-interaction --optimize-autoloader
else
    echo "[DOCKER] Refreshing autoloader..."
    composer dump-autoload --optimize
fi

# Start the bot using the Main.php entry point
echo "[DOCKER] Starting Sharkord Bot..."
exec php Main.php