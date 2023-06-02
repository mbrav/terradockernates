FROM alpine:3

RUN apk update && \
    apk add --no-cache bash

COPY ./container/docker-net/entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "entrypoint.sh" ]
