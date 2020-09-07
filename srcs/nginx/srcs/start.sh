adduser -D "admin"
echo "admin:admin" | chpasswd

telegraf &
nginx -g 'daemon off;'
