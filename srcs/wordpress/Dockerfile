FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN wget -O wordpress.zip https://wordpress.org/latest.zip
RUN unzip /wordpress.zip -d /usr/share/ 1> /dev/null
RUN rm wordpress.zip
RUN rm -rf /usr/share/wordpress/wp-config.php
RUN rm -rf /var/cache/apk/*

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

COPY srcs/wp-config.php /usr/share/wordpress/wp-config.php

RUN mkdir -p /etc/telegraf
COPY ./srcs/telegraf.conf /etc/telegraf/telegraf.conf

COPY ./srcs/start.sh .
RUN chmod 755 /start.sh

EXPOSE 5050

CMD sh ./start.sh
