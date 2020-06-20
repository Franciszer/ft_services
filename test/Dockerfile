# FROM Image : alpine
FROM alpine:latest

# Install telegraf for monitoring
RUN mkdir /etc/telegraf
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.13.3-static_linux_amd64.tar.gz
RUN tar -C . -xzf telegraf-1.13.3-static_linux_amd64.tar.gz
RUN chmod +x telegraf/*
RUN cp telegraf/telegraf /usr/bin/
RUN rm -rf telegraf-1.13.3-static_linux_amd64.tar.gz telegraf
RUN rm -rf /var/cache/apk/*

 COPY telegraf-tmp.conf /etc/telegraf/telegraf.conf
COPY setup.sh .

RUN chmod +x setup.sh

EXPOSE 4999

# CMD ./setup.sh