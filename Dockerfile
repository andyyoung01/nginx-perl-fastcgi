FROM gliderlabs/alpine:3.4
RUN echo "@perl-5.20 http://dl-3.alpinelinux.org/alpine/v3.2/main">>/etc/apk/repositories \
	&& apk add -U perl@edgea nginx

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

CMD ["/usr/bin/supervisord"]
	

