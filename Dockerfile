ARG from=alpine:latest
FROM ${from} AS build

RUN apk update && \
    apk add --no-cache build-base curl-dev gdbm-dev hiredis-dev json-c-dev jq krb5-dev libc-dev libcouchbase-dev libidn-dev libmemcached-dev linux-headers mariadb-dev openssl openssl-dev openldap-dev pcre-dev perl-dev postgresql-dev python3-dev ruby-dev samba-dev sqlite-dev talloc-dev unbound-dev unixodbc-dev

ARG URL=https://api.github.com/repos/FreeRADIUS/freeradius-server/releases/latest
RUN NAME=$(wget -q -O - $URL | jq -r '.assets[] | select(.name | endswith(".tar.gz")) | .name') && \
    DOWNLOAD_URL=$(wget -q -O - $URL | jq -r '.assets[] | select(.name | endswith(".tar.gz")) | .browser_download_url') && \
    wget $DOWNLOAD_URL && \
    tar -xf $NAME && \
    DIR=$(echo "$NAME" | sed 's/\.tar\.gz$//') && \
    cd $DIR && \
    ./configure --prefix=/opt && \
    make -j2 && \
    make install

WORKDIR /

COPY . .

RUN chmod +x post-install.sh && \
    ./post-install.sh

FROM ${from}
COPY --from=build /opt /opt

RUN apk update && \
    apk add --no-cache openssl talloc libressl make pcre libwbclient tzdata && \
    ln -s /opt/etc/raddb /etc/raddb

WORKDIR /opt/

RUN chmod +x entrypoint.sh && \ 
    chmod +x new-certs.sh && \
    ln -s /opt/new-certs.sh /usr/local/bin/new-certs

EXPOSE 1812/udp

HEALTHCHECK --start-period=1m --interval=5m \
    CMD netstat -an | grep 1812 > /dev/null; if [ 0 != $? ]; then exit 1; fi;

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["radiusd"]
