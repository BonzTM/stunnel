FROM alpine:3

RUN apk add --no-cache stunnel libressl openssl

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME /etc/stunnel

ENTRYPOINT ["/entrypoint.sh"]