FROM php:8.2-apache
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git
RUN docker-php-ext-install pdo pdo_mysql gd
COPY . /var/www/html
WORKDIR /var/www/html
EXPOSE 80
