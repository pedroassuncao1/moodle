FROM php:8.2-apache-bookworm

# Configure apt retries for slow connections
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99retries \
    && echo 'Acquire::http::Timeout "120";' >> /etc/apt/apt.conf.d/99retries

# Grupo 1: ICU (intl) + mbstring
RUN apt-get update && apt-get install -y --no-install-recommends \
    libicu-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Grupo 2: zip + gd (jpeg)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j1 \
        mysqli \
        intl \
        mbstring \
        zip \
        gd \
        opcache \
        exif

RUN a2enmod rewrite

RUN { \
    echo 'max_input_vars = 5000'; \
    echo 'upload_max_filesize = 128M'; \
    echo 'post_max_size = 128M'; \
    echo 'max_execution_time = 300'; \
    echo 'memory_limit = 256M'; \
} > /usr/local/etc/php/conf.d/moodle.ini

COPY apache-moodle.conf /etc/apache2/sites-available/000-default.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
