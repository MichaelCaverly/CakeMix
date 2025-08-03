FROM php:8-apache

WORKDIR /var/www/html/

#set our application folder as an environment variable
ENV APP_HOME=/var/www/html

#set UID/GID
ARG APP_UID=1000
ARG APP_GID=1000


################################
#          OS config           #
################################


# Create non-root user and group matching host user
RUN groupadd -g $APP_GID appgroup && \
    useradd -u $APP_UID -g appgroup -m appuser

# Update the system
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    cron g++ gettext libicu-dev openssl \
    libc-client-dev libkrb5-dev  \
    libxml2-dev libfreetype6-dev \
    libgd-dev libmcrypt-dev bzip2 \
    libbz2-dev libtidy-dev libcurl4-openssl-dev \
    libz-dev libmemcached-dev libxslt-dev git-core libpq-dev \
    libzip4 libzip-dev libwebp-dev libmagickwand-dev libmagickcore-dev default-mysql-client

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer


################################
#          PHP config          #
################################


RUN docker-php-ext-install bcmath bz2 calendar dba exif gettext iconv intl soap tidy xsl zip && \
    docker-php-ext-install mysqli pgsql pdo pdo_mysql pdo_pgsql  && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    docker-php-ext-configure hash --with-mhash && \
    pecl install redis && docker-php-ext-enable redis && \
    pecl install mcrypt && docker-php-ext-enable mcrypt && \
    pecl install imagick && docker-php-ext-enable imagick

COPY ./custom-php.ini $PHP_INI_DIR/conf.d/

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"


################################
#        Apache config         #
################################


# Make Apache run as non-root user
RUN sed -i "s/^User .*/User appuser/" /etc/apache2/apache2.conf && \
    sed -i "s/^Group .*/Group appgroup/" /etc/apache2/apache2.conf

#change the web_root to cakephp /var/www/html/cake/webroot folder
RUN sed -i -e "s/html/html\/cake\/webroot/g" /etc/apache2/sites-enabled/000-default.conf

# enable apache module rewrite
RUN a2enmod rewrite


################################
#          Entrypoint          #
################################


# Copy the custom entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Default command that runs if no other command is provided (starts Apache in the foreground)
CMD ["apache2-foreground"]

# Override the default entrypoint to use the custom script
# This allows for custom setup before executing the CMD
ENTRYPOINT ["entrypoint.sh"]
