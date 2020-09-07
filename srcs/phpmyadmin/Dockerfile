FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz
RUN tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz
RUN rm phpMyAdmin-5.0.2-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.2-all-languages /usr/share/phpmyadmin
RUN rm -rf /var/cache/apk/*


COPY srcs/config.inc.php /usr/share/phpmyadmin/config.inc.php

RUN mkdir -p /etc/telegraf
COPY ./srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY ./srcs/start.sh /start.sh

EXPOSE 5000

CMD ["/start.sh"]
