#!/bin/bash
set -e

# If a REPO_URL environment variable is provided, clone the repo
# Otherwise, assume the code was copied into the image or mounted
if [ -n "$REPO_URL" ]; then
    echo "[DOCKER] Cloning repository: $REPO_URL"
    git clone "$REPO_URL" .
fi

# Ensure Composer dependencies are installed
# This is required for the 'Sharkord' and 'Models' namespaces to work
if [ ! -d "vendor" ]; then
    echo "[DOCKER] Installing Composer dependencies..."
    composer install --no-interaction --optimize-autoloader
else
    echo "[DOCKER] Refreshing autoloader..."
    composer dump-autoload --optimize
fi

# Start the bot
# This executes the entry point defined in your project
echo "[DOCKER] Starting Sharkord Bot..."
exec php Main.php