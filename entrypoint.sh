#!/bin/bash
set -e

# Default to the requested repo, but allow override
REPO_URL="${REPO_URL:-https://github.com/BuzzMoody/Sharkord-Bot.git}"

# Determine which branch to pull based on DEV environment variable
BRANCH_NAME="main"
if [ "$DEV" = "true" ]; then
    BRANCH_NAME="dev"
    echo "[DOCKER] DEV mode detected. Target branch: dev"
else
    echo "[DOCKER] Production mode. Target branch: main"
fi

# 1. Check if we need to pull the code
if [ ! -f "Main.php" ]; then
    echo "[DOCKER] Main.php not found. Fetching source from: $REPO_URL (Branch: $BRANCH_NAME)"
    
    # Clean up any partial previous attempts
    rm -rf /tmp/repo_clone
    
    # Clone the specific branch
    git clone -b "$BRANCH_NAME" "$REPO_URL" /tmp/repo_clone
    
    # Move everything from the temp folder to the current working directory (/app)
    # Using 'cp -a' to preserve permissions and hidden files like .git
    cp -a /tmp/repo_clone/. .
    
    # Clean up
    rm -rf /tmp/repo_clone
    echo "[DOCKER] Files moved to /app successfully."
else
    echo "[DOCKER] Source code already exists in /app. Skipping git pull."
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