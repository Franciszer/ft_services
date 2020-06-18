#!/bin/sh

apk update
apk add openrc nginx openssl openssh --no-cache
apk add --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

adduser -D "$SSH_USER"
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

mkdir -p /run/nginx

openrc
touch /run/openrc/softlevel
rc-update add sshd