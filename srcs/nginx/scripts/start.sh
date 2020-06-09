adduser -D "$SSH_USER"
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

/usr/sbin/sshd
/usr/sbin/nginx -g 'daemon off;'
