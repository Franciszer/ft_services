FROM debian:buster
MAINTAINER frthierr <frthierr@42.student.fr>
COPY files/server.config /etc/nginx/sites-available/
COPY files/init_server.sh .
COPY files/index.html /var/www/html/
CMD bash init_server.sh && tail -f /dev/null
EXPOSE 80 443 4000