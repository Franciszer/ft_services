FROM alpine:latest

ENV TIMEZONE Europe/Paris
ENV VERSION_WORDPRESS 4.9.6

# Installing dependencies
RUN apk add --no-cache --virtual .build-deps unzip
RUN apk add --no-cache apache2 php7 php7-apache2 php7-openssl php7-xml php7-pdo php7-mcrypt php7-session php7-mysqli php7-zlib su-exec
RUN mkdir -p /run/apache2 /run/httpd

# Work path
WORKDIR /scripts

# Download & install wordpress
ADD https://wordpress.org/wordpress-${VERSION_WORDPRESS}.zip ./
RUN unzip -q wordpress-${VERSION_WORDPRESS}.zip -d ./
RUN rm -rf /var/www/localhost/htdocs
RUN mv wordpress/ /var/www/localhost/htdocs
RUN rm /scripts/wordpress-${VERSION_WORDPRESS}.zip \
    /var/www/localhost/htdocs/wp-config-sample.php \
    /var/www/localhost/htdocs/license.txt \
    /var/www/localhost/htdocs/readme.html
RUN chown -R apache:apache /var/www/localhost/htdocs
RUN apk del .build-deps

# Copy of the HTTPD startup script
COPY scripts/start.sh start.sh
COPY files/wp-config.php /var/www/localhost/htdocs/wp-config.php

EXPOSE 80

ENTRYPOINT [ "./start.sh" ]
