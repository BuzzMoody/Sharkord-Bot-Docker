# Using PHP 8.5 as requested (Note: If 8.5 is not released yet, switch to 8.4)
FROM php:8.5-cli-alpine

# Install system dependencies
# - git/unzip: Required for Composer
# - tzdata: Required for Timezone configuration
# - bash: For our entrypoint script
RUN apk add --no-cache git unzip tzdata bash

# Install PHP Extensions required by ReactPHP/Ratchet
RUN docker-php-ext-install pcntl sockets bcmath

# Get Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to our script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]