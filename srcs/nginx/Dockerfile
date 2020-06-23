FROM alpine:latest

# update && install nginx && bash && openssl && folder for nginx pid
RUN apk update && apk add nginx
RUN apk add --no-cache --upgrade bash
RUN apk add openssl && mkdir -p var/run/nginx
RUN apk add openssl openssh
RUN rm -rf /var/cache/apk/*

RUN adduser -D -g 'user' user
RUN mkdir /www && chown -R user:user /var/lib/nginx
RUN chown -R user:user /www

# SSL
RUN mkdir /etc/nginx/ssl \
&& openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=frthierr/CN=ft_services"

# NGINX 
RUN rm /etc/nginx/nginx.conf
COPY srcs/nginx.conf /etc/nginx/nginx.conf

# SSH
COPY srcs/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY srcs/sshd_config /etc/ssh/

COPY srcs/index-tmp.html /www/index.html
COPY srcs/setup.sh .

RUN chmod +x setup.sh
RUN chmod 700 /etc/ssh/ssh_host_rsa_key

EXPOSE 4000 80 443
CMD ./setup.sh
