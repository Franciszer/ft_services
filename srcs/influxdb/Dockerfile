FROM alpine:3.12.0

RUN apk update && apk add influxdb
RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN mkdir -p /etc/telegraf

COPY ./telegraf.conf /etc/telegraf/telegraf.conf

EXPOSE 8086

COPY ./init-influxdb.sh /init-influxdb.sh

ENTRYPOINT ["/init-influxdb.sh"]
