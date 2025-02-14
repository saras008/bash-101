#!/bin/sh

# Define PHP and Redis versions
PHP_VERSION='8.0.19'
REDIS_VERSION='5.3.4'

# Install required dependencies
yum -y install epel-release pcre pcre-devel zlib-devel zlib libxml2-devel libxml2 \
    openssl openssl-devel libcurl libcurl-devel libjpeg-turbo-devel libjpeg-turbo \
    libpng-devel libpng libXpm-devel libXpm freetype-devel libvpx-devel mysql-devel \
    postgresql-devel sqlite-devel libwebp-devel oniguruma-devel
yum update -y

# Create sources directory if it does not exist
mkdir -p /root/sources
cd /root/sources

# Download PHP source and necessary libraries
wget https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz
wget https://vault.centos.org/centos/8/AppStream/x86_64/os/Packages/libzip-devel-1.6.1-1.module_el8.3.0+396+9a0d79d6.x86_64.rpm
wget https://vault.centos.org/centos/8/AppStream/x86_64/os/Packages/libzip-1.6.1-1.module_el8.3.0+396+9a0d79d6.x86_64.rpm

# Install libzip
yum install -y libzip-1.6.1-1.module_el8.3.0+396+9a0d79d6.x86_64.rpm \
    libzip-devel-1.6.1-1.module_el8.3.0+396+9a0d79d6.x86_64.rpm

# Extract and compile PHP
tar -zxvf php-${PHP_VERSION}.tar.gz
cd php-${PHP_VERSION}

./configure \
    --prefix=/opt/php80 \
    --enable-gd=/usr/lib64/ \
    --with-jpeg \
    --with-freetype \
    --with-webp \
    --with-xpm \
    --with-zlib \
    --enable-sysvshm \
    --with-openssl \
    --with-pgsql \
    --enable-soap \
    --with-curl \
    --with-libdir=/usr/lib64/ \
    --enable-xml \
    --enable-session \
    --enable-cli \
    --with-iconv \
    --enable-simplexml \
    --enable-ctype \
    --enable-filter \
    --enable-ftp \
    --enable-xmlreader \
    --enable-phar \
    --with-pear \
    --enable-fpm \
    --enable-dom \
    --enable-pdo \
    --enable-mbstring \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-zip \
    --enable-mysqlnd \
    --with-mysqli \
    --with-libxml \
    --enable-sockets \
    --enable-opcache

make
make install

echo "PHP installation completed."

# Install Redis module
echo "Installing Redis module..."
cd /root/sources
wget https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz
tar -zxvf redis-${REDIS_VERSION}.tgz
cd redis-${REDIS_VERSION}

/opt/php80/bin/phpize
./configure --with-php-config=/opt/php80/bin/php-config
make
make install

echo "Redis module installation completed."

# Install Mcrypt module
echo "Installing Mcrypt module..."
cd /root/sources
wget https://pecl.php.net/get/mcrypt-1.0.5.tgz
tar -xvf mcrypt-1.0.5.tgz
cd mcrypt-1.0.5

/opt/php80/bin/phpize
./configure --with-php-config=/opt/php80/bin/php-config
make
make install

echo "Mcrypt module installation completed."

# Install PSR module for Phalcon
echo "Installing PSR module for Phalcon..."
cd /root/sources
wget https://pecl.php.net/get/psr-1.2.0.tgz
tar -xvf psr-1.2.0.tgz
cd psr-1.2.0

/opt/php80/bin/phpize
./configure --with-php-config=/opt/php80/bin/php-config
make
make install

echo "Installation completed."
