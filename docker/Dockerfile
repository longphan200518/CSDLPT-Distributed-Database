FROM php:8.2-apache

# Install prerequisites and Microsoft SQL Server ODBC drivers
RUN apt-get update \
 && apt-get install -y gnupg2 unixodbc-dev curl apt-transport-https ca-certificates \
 && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg \
 && echo "deb [arch=amd64] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 \
 && echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /etc/bash.bashrc \
 && pecl install sqlsrv \
 && pecl install pdo_sqlsrv \
 && docker-php-ext-enable sqlsrv pdo_sqlsrv \
 && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV APACHE_DOCUMENT_ROOT /var/www/html

# Copy application source (build context is project root)
COPY src/ /var/www/html/

RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]
