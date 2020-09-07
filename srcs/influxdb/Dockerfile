FROM alpine:latest

RUN apk update && apk add influxdb
RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN mkdir -p /etc/telegraf

COPY ./srcs/telegraf.conf /etc/telegraf/telegraf.conf

EXPOSE 8086

COPY ./srcs/start.sh /start.sh

ENTRYPOINT ["/start.sh"]
