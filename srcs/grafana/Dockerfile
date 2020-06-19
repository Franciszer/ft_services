FROM alpine:latest

RUN apk update && apk add --no-cache --upgrade bash \
&& apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat

RUN wget https://dl.grafana.com/oss/release/grafana-7.0.3.linux-amd64.tar.gz
RUN tar -xzvf grafana-7.0.3.linux-amd64.tar.gz
# RUN rm /grafana-7.0.3/conf/defaults.ini
RUN rm -rf /var/cache/apk/* 	

# COPY ./srcs/defaults.ini ./grafana-7.0.3/conf/
COPY ./srcs/grafana.db ./grafana-7.0.3/data/
COPY ./srcs/datasources.yaml ./grafana-7.0.3/conf/provisioning/datasources/
COPY ./srcs/dashboard.yaml ./grafana-7.0.3/conf/provisioning/dashboards/
COPY ./srcs/*.json . ./grafana-7.0.3/conf/provisioning/dashboards/
COPY srcs/start.sh .

RUN chmod +x start.sh

EXPOSE 3000

CMD ./start.sh