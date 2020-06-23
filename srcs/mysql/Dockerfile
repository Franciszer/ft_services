FROM alpine:latest

RUN apk update
RUN apk add mysql mysql-client
RUN rm -rf /var/cache/apk/*

COPY scripts/start.sh /bin/start.sh
COPY files/my.cnf /etc/mysql/my.cnf

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["/bin/start.sh"]
