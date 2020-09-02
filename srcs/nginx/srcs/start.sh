adduser -D "admin"
echo "admin:admin" | chpasswd

/etc/init.d/ssh_check.sh &
telegraf &
nginx -g 'daemon off;'
