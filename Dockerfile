FROM php:8.3-apache

# ================================
# 1. Instalar dependencias del sistema y extensiones PHP
# ================================
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev unzip git curl \
    && docker-php-ext-install pdo pdo_mysql gd mbstring zip exif pcntl bcmath opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ================================
# 2. Instalar Composer globalmente
# ================================
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# ================================
# 3. Habilitar mod_rewrite y permitir .htaccess
# ================================
RUN a2enmod rewrite \
    && echo '<Directory /var/www/html/>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/allow-override.conf \
    && a2enconf allow-override

# ================================
# 4. Configurar el DocumentRoot dinámico (si se pasa por ARG)
# ================================
ARG APACHE_DOCUMENT_ROOT=/var/www/html
ENV APACHE_DOCUMENT_ROOT=${APACHE_DOCUMENT_ROOT}
RUN sed -ri -e "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf

# ================================
# 5. Copiar el proyecto
# ================================
COPY . /var/www/html

# ================================
# 6. Ajustar permisos
# ================================
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# ================================
# 7. Instalar dependencias PHP (si existe composer.json)
# ================================
WORKDIR /var/www/html
RUN if [ -f composer.json ]; then composer install --no-interaction --prefer-dist; fi

# ================================
# 8. Exponer puerto y comando final
# ================================
EXPOSE 80
CMD ["apache2-foreground"]

