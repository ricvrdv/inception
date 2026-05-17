FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php-mysql \
    php-curl \
    php-gd \
    wget \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

COPY conf/ /etc/php/8.2/fpm/pool.d/
WORKDIR /usr/local/bin
COPY tools/ .
RUN chmod +x setup_wordpress.sh 

EXPOSE 9000

ENTRYPOINT ["setup_wordpress.sh"]