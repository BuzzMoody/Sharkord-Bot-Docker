# Using PHP 8.5 (Fallback to 8.4 if 8.5 is not yet available)
FROM php:8.5-cli-alpine

# 1. Install system dependencies
# - git/unzip: Required for Composer
# - tzdata: Required for Timezone configuration
# - bash: For our entrypoint script
# - shadow: Provides usermod/groupmod for Alpine
# - su-exec: Alpine's lightweight 'gosu' alternative
RUN apk add --no-cache git unzip tzdata bash shadow su-exec

# 2. Install PHP Extensions
RUN docker-php-ext-install pcntl bcmath

# 3. Create the generic user and group
# We create them with ID 1000 as a default starting point
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -D appuser
	
ENV TZ=Australia/Melbourne

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
	&& echo "date.timezone=${TZ}" > /usr/local/etc/php/conf.d/timezone.ini

# 4. Get Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Set working directory
WORKDIR /app

# 6. Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Ensure the app directory exists and is owned by our user
RUN chown appuser:appgroup /app

# 7. Set the entrypoint (Container starts as root to allow ID re-mapping)
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]