FROM chrohrer/freeradius:latest

LABEL maintainer="chris.rohrer@ubuntunet.net"

WORKDIR /radius

RUN apk update && apk upgrade && \
    apk add --update openssl freeradius-eap freeradius-ldap make && \
    rm /var/cache/apk/*

RUN /etc/raddb/certs/bootstrap && \
    chmod -R +r /etc/raddb/certs

COPY Radius/radiusd.conf /etc/raddb/radiusd.conf
COPY Radius/mods-config/attr_filter/pre-proxy /etc/raddb/mods-config/attr_filter/pre-proxy
COPY Radius/mods-enabled/f_ticks /etc/raddb/mods-enabled/f_ticks

EXPOSE 1812/udp 1813/udp

CMD ["radiusd", "-sfxxl", "stdout"]
