FROM debian:jessie-slim

ENV NGINX_VERSION 1.10.3-1~jessie
ENV NGX_NJS_VERSION 1.10.3.0.0.20160414.1c50334fbea6-1~jessie

RUN apt-get update && \
    apt-get install -y wget && \
    echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list && \
    wget -q http://nginx.org/keys/nginx_signing.key && \
    apt-key add nginx_signing.key && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
            ca-certificates \
            nginx=${NGINX_VERSION} \
            nginx-module-xslt=${NGINX_VERSION} \
            nginx-module-geoip=${NGINX_VERSION} \
            nginx-module-image-filter=${NGINX_VERSION} \
            nginx-module-perl=${NGINX_VERSION} \
            nginx-module-njs=${NGX_NJS_VERSION} \
            gettext-base \
    && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
