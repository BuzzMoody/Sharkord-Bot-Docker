# Use the requested PHP 8.5 CLI Alpine image
FROM php:8.5-cli-alpine

# Install system dependencies
# libzip-dev and zip are required for the PHP zip extension
# git, unzip, and bash are required for Composer and repo management
RUN apk add --no-cache \
    bash \
    git \
    unzip \
    libzip-dev \
    zip

# Install PHP extensions
# 'zip' is for Composer; 'pcntl' allows the ReactPHP loop to handle system signals
RUN docker-php-ext-install zip pcntl

# Install Composer from the official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /app

# Copy the project files (if building locally)
COPY . .

# Copy and prepare the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]