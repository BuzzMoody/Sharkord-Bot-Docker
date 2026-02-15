#!/bin/bash
set -e

REPO_URL="${REPO_URL:-https://github.com/BuzzMoody/Sharkord-Bot.git}"

# 1. Check if we need to pull the code
if [ ! -f "Main.php" ]; then
    echo "[DOCKER] Main.php not found. Fetching source from: $REPO_URL"
    
    # Clean up any partial previous attempts
    rm -rf /tmp/repo_clone
    
    # Clone the repo
    git clone "$REPO_URL" /tmp/repo_clone
    
    # Move everything from the temp folder to the current working directory (/app)
    # Using 'cp -a' to preserve permissions and hidden files like .git
    cp -a /tmp/repo_clone/. .
    
    # Clean up
    rm -rf /tmp/repo_clone
    echo "[DOCKER] Files moved to /app successfully."
else
    echo "[DOCKER] Source code already exists in /app."
fi

# 2. Verify composer.json exists before running composer
if [ ! -f "composer.json" ]; then
    echo "[ERROR] composer.json not found in $(pwd)!"
    echo "[DEBUG] Current directory contents:"
    ls -la
    exit 1
fi

# 3. Handle Dependencies
if [ ! -d "vendor" ]; then
    echo "[DOCKER] Installing Composer dependencies..."
    composer install --no-interaction --optimize-autoloader
else
    echo "[DOCKER] Refreshing autoloader..."
    composer dump-autoload --optimize
fi

echo "[DOCKER] Starting Sharkord Bot..."
exec php Main.php