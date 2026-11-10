FROM composer:latest AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

COPY . .
RUN composer dump-autoload --no-dev --optimize

FROM php:8.2-apache
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git
RUN docker-php-ext-install pdo pdo_mysql gd
RUN a2enmod rewrite

COPY --from=vendor /app /var/www/html
WORKDIR /var/www/html

RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
EXPOSE 80
