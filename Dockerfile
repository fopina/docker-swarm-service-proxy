FROM alpine:3.23

RUN apk add --no-cache socat docker-cli

ADD entry.sh /usr/bin/entry.sh

ENTRYPOINT [ "/usr/bin/entry.sh" ]
