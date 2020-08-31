FROM alpine:latest

RUN apk update \
	&& apk add mysql mysql-client

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN mkdir -p /etc/telegraf
COPY ./srcs/telegraf.conf /etc/telegraf/telegraf.conf

ADD srcs/init.sh .
ADD srcs/my.cnf /etc/

EXPOSE 3306

ENTRYPOINT ["/bin/sh", "/init.sh"]
