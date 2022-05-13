FROM php:7.3.29-apache
ENV ACCEPT_EULA=Y
ENV TIMEZONE Asia/Bangkok

#Apache
RUN a2enmod rewrite

# TimeZone
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" >  /etc/timezone

RUN apt-get update && apt-get install -y gnupg2
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list 
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev 
RUN pecl install sqlsrv-5.8.0
RUN pecl install pdo_sqlsrv-5.8.0
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# PHP ini
ADD ./php.ini /usr/local/etc/php/conf.d/custom.php.ini

RUN echo "extension= pdo_sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
RUN echo "extension= sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`