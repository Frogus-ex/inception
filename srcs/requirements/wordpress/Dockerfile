FROM debian:bookworm

RUN	apt-get update -y && \
    	apt-get install -y \
    	wget \
    	curl \
	php-fpm \
	php-mysql \
	mariadb-client \
	ca-certificates && \
	apt clean && rm -rf /var/lib/apt/lists/*

RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY	./tools/wp_config.sh /usr/local/bin/wp_config.sh
RUN chmod +x /usr/local/bin/wp_config.sh

COPY ./tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html/wordpress
WORKDIR /var/www/html/wordpress

ENTRYPOINT ["/usr/local/bin/wp_config.sh"]
