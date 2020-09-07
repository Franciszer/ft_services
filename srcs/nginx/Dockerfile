FROM alpine:latest

RUN apk update \
	&& apk upgrade \
	&& apk add nginx \
	&& apk add openssl openssh

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN rm /etc/nginx/conf.d/default.conf
COPY srcs/default.conf /etc/nginx/conf.d/default.conf
RUN sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
RUN mkdir /run/nginx
RUN mkdir -p /usr/share/nginx/html
ADD srcs/index.html /usr/share/nginx/html/index.html
RUN chmod 755 /usr/share/nginx/html/index.html
RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key

COPY srcs/start.sh /start.sh

RUN mkdir -p /etc/telegraf
COPY ./srcs/telegraf.conf /etc/telegraf/telegraf.conf

EXPOSE 80 443 22

CMD /usr/sbin/sshd ;  sh /start.sh ;
