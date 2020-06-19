FROM alpine:latest

RUN apk update && apk add influxdb
# RUN apk add --no-cache --upgrade bash
COPY srcs/start.sh .

RUN chmod +x start.sh

EXPOSE 8086

CMD ./start.sh