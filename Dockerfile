FROM gliderlabs/alpine:3.4

RUN apk add -U --virtual build-dependencies build-base gcc abuild binutils binutils-doc gcc-doc \
        && apk add --virtual cmake-pkgs cmake cmake-doc extra-cmake-modules extra-cmake-modules-doc \
        && apk add --virtual ccache-pkgs ccache ccache-doc

RUN echo "@perl-5.20 http://dl-3.alpinelinux.org/alpine/v3.2/main">>/etc/apk/repositories \
	&& apk add -U perl@perl-5.20 nginx

COPY nph-proxy.cgi /var/www
COPY default.conf ssl_config /etc/nginx/conf.d/
COPY server.crt server_nopwd.key /etc/nginx/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /var/www
VOLUME ["/var/log"]
EXPOSE 80 443

RUN ./nph-proxy.cgi init \
        && cpan FCGI \
        && cpan FCGI::ProcManager

RUN rm -rf /var/cache/apk/*

CMD ["/usr/bin/supervisord"]
	

