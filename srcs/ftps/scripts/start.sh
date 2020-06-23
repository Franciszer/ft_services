#!/bin/sh
apk upgrade
apk update
apk add openssl
apk add pure-ftpd --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
rm -rf /var/cache/apk/*

yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem

mkdir -p /ftps/$FTP_USER
adduser -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

/usr/sbin/pure-ftpd -j -Y 1 -p 21000:21000 -P "MINIKUBE_IP"
