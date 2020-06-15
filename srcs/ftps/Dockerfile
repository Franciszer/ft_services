FROM alpine:latest

RUN apk upgrade && \
    apk update

COPY scripts/start-tmp.sh /bin/start-tmp.sh

ENTRYPOINT ["/bin/start-tmp.sh"]
