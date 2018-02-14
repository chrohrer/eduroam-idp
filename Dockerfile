FROM chrohrer/freeradius:latest

LABEL maintainer="chris.rohrer@ubuntunet.net"

WORKDIR /radius

RUN apk update && apk upgrade && \
    apk add --update freeradius-eap && \
    rm /var/cache/apk/*

COPY Radius/mods-config/attr_filter/pre-proxy /etc/raddb/mods-config/attr_filter/pre-proxy
COPY Radius/mods-enabled/f_ticks /etc/raddb/mods-enabled/f_ticks

EXPOSE 1812/udp 1813/udp

CMD ["radiusd", "-sfxl", "stdout"]
