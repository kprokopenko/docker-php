# Composer Docker Container
# Base Dockerfile: composer/base
FROM php:5.4-cli
MAINTAINER Konstantin Prokopenko <kprokopenko@gmail.com>

# Packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libbz2-dev \
    libssl-dev \
    php-pear \
    curl \
    git \
    subversion \
    unzip \
  && rm -r /var/lib/apt/lists/*

# PHP Extensions
RUN pecl install mongo \
  && docker-php-ext-enable mongo \
  && docker-php-ext-install mcrypt zip bz2 mbstring bcmath \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd

# Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Disable Populating Raw POST Data
# Not needed when moving to PHP 7.
# http://php.net/manual/en/ini.core.php#ini.always-populate-raw-post-data
RUN echo "always_populate_raw_post_data=-1" > $PHP_INI_DIR/conf.d/always_populate_raw_post_data.ini

# Set up the volumes and working directory
VOLUME ["/app"]
WORKDIR /app

# Set up the command arguments
CMD ["-"]
ENTRYPOINT ["php"]
