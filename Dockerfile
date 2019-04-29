#FROM freeradius/freeradius-server:3.0.19-alpine
FROM chrohrer/freeradius:0.5

ARG RADIUSD_OPTIONS=sfxxl
ARG RADIUSD_LOGFILE=stdout
ENV RADIUSD_OPTIONS ${RADIUSD_OPTIONS}
ENV RADIUSD_LOGFILE ${RADIUSD_LOGFILE}

LABEL maintainer="chris.rohrer@ubuntunet.net"

WORKDIR /radius

RUN apk update && apk upgrade && \
    apk add --update openssl freeradius-eap freeradius-ldap freeradius-postgresql freeradius-mysql make && \
    rm /var/cache/apk/*

RUN /etc/raddb/certs/bootstrap && \
    chmod -R +r /etc/raddb/certs

COPY Radius/radiusd.conf /etc/raddb/radiusd.conf
COPY Radius/mods-config/attr_filter/pre-proxy /etc/raddb/mods-config/attr_filter/pre-proxy
COPY Radius/mods-enabled/f_ticks /etc/raddb/mods-enabled/f_ticks

EXPOSE 1812/udp 1813/udp

# CMD ["radiusd", "-${RADIUSD_OPTIONS}", "${RADIUSD_LOGFILE}"]
CMD radiusd -${RADIUSD_OPTIONS} -l ${RADIUSD_LOGFILE}
