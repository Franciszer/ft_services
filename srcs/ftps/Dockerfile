FROM alpine:3.12.0

RUN apk --no-cache add vsftpd openssl

ARG IP
RUN echo $IP > ip

RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY start_vsftpd.sh /bin/start_vsftpd.sh
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

EXPOSE 21 31000

ENTRYPOINT ["/bin/start_vsftpd.sh"]
