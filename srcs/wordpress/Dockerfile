FROM alpine:latest

ENV TIMEZONE Europe/Paris
ENV VERSION_WORDPRESS 4.9.6
ENV SERVER_PATH /var/www/localhost/htdocs

RUN apk add --no-cache --virtual .build-deps unzip
RUN apk add --no-cache apache2 php7 php7-apache2 php7-openssl php7-xml php7-pdo php7-mcrypt php7-session php7-mysqli php7-zlib su-exec
RUN mkdir -p /run/apache2 /run/httpd

WORKDIR /scripts

ADD https://wordpress.org/wordpress-${VERSION_WORDPRESS}.zip ./
RUN unzip -q wordpress-${VERSION_WORDPRESS}.zip -d ./ && \
        rm -rf ${SERVER_PATH} && \
        mv wordpress/ ${SERVER_PATH} && \
        rm /scripts/wordpress-${VERSION_WORDPRESS}.zip \
            ${SERVER_PATH}/wp-config-sample.php \
            ${SERVER_PATH}/license.txt \
            ${SERVER_PATH}/readme.html && \
        chown -R apache:apache ${SERVER_PATH} && \
        apk del .build-deps

COPY scripts/start.sh start.sh
COPY files/wp-config.php ${SERVER_PATH}/wp-config.php

EXPOSE 80

ENTRYPOINT [ "./start.sh" ]
