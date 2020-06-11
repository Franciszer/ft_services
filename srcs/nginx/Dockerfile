FROM alpine 

USER root

# Copy files
COPY srcs/instal_model.sh /tmp/instal_model.sh
COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY files/index.html /var/www/localhost/htdocs/index.html

# Run Install
RUN sh /tmp/instal_model.sh 

EXPOSE 22 80 443

ENTRYPOINT /etc/init.d/telegraf start; /etc/init.d/sshd start; nginx -g "daemon off;"