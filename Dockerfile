FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git

RUN docker-php-ext-install pdo pdo_mysql gd
RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./

RUN mkdir -p storage/framework/sessions storage/framework/views storage/framework/cache bootstrap \
    && echo "<?php return Illuminate\Foundation\Application::configure(basePath: dirname(__DIR__))->withRouting(web: __DIR__.'/../routes/web.php', commands: __DIR__.'/../routes/console.php', health: '/up')->withMiddleware(function ($middleware) {})->withExceptions(function ($exceptions) {})->create();" > bootstrap/app.php \
    && composer install --no-dev --no-scripts --prefer-dist

COPY . .

RUN composer dump-autoload --no-dev --optimize \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80
