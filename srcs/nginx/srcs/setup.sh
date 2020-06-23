adduser -D "admin"
echo "admin:admin" | chpasswd

/usr/sbin/sshd
nginx -g "daemon off;"