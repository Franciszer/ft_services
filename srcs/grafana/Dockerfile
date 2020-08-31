FROM alpine:3.12.0

RUN apk update && apk add --no-cache --upgrade bash

RUN apk add telegraf --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN wget https://dl.grafana.com/oss/release/grafana-6.7.2.linux-amd64.tar.gz \
&& tar -zxvf grafana-6.7.2.linux-amd64.tar.gz

RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat

COPY ./grafana.db ./grafana-6.7.2/data/
COPY start.sh /start.sh

RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ./start.sh
