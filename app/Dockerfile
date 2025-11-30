FROM php:8.2-apache


#Install mysqli extension
RUN docker-php-ext-install mysqli


#sET WORKING DIRECTORY
WORKDIR /var/www/html

# Copy all project files into container
COPY . /var/www/html