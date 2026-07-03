# Use Composer image to install PHP dependencies during build
FROM composer:2 as builder
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --classmap-authoritative

# Use Apache-enabled PHP runtime for Render.com
FROM php:8.2-apache
WORKDIR /var/www/html

# Copy application source and installed dependencies
COPY --from=builder /app/vendor /var/www/html/vendor
COPY --from=builder /app/composer.json /var/www/html/composer.json
COPY --from=builder /app/composer.lock /var/www/html/composer.lock
COPY . /var/www/html

# Ensure Apache serves the correct directory
EXPOSE 80
CMD ["apache2-foreground"]
