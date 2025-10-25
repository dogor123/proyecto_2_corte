FROM php:8.3-apache

# Instalar dependencias del sistema y extensiones PHP necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev unzip git curl \
    && docker-php-ext-install pdo pdo_mysql gd mbstring zip exif pcntl bcmath opcache

# Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Establecer el DocumentRoot desde variable de entorno
ARG APACHE_DOCUMENT_ROOT
ENV APACHE_DOCUMENT_ROOT=${APACHE_DOCUMENT_ROOT}
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copiar los archivos del proyecto
COPY . /var/www/html

# Instalar dependencias PHP automáticamente (si composer.json existe)
WORKDIR /var/www/html
RUN composer install --no-interaction --prefer-dist || true

EXPOSE 80
CMD ["apache2-foreground"]
