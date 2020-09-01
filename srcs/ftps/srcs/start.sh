#!/bin/sh

NAME=admin
PASS=admin
FOLDER="/ftp/user"

echo -e "$PASS\n$PASS" | adduser -h $FOLDER -s /sbin/nologin -u 1000 $NAME

mkdir -p $FOLDER
chown $NAME:$NAME $FOLDER
unset NAME PASS FOLDER UID

IP=$(cat ip)

telegraf &
./usr/sbin/vsftpd -opasv_address=$IP /etc/vsftpd/vsftpd.conf
