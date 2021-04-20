FROM uralm1/httpd-uwc:latest

###
#RUN set -eux; \
#  apt-get update; \
#  apt-get install -y --no-install-recommends \
#    libunwind8 \
#  ; \
#  rm -rf /var/lib/apt/lists/*
###

ENV PUB_ROOT /1c-pub
ENV PLATFORM_VER "8.3.18.1363"
# next meant to be replaced in cmdline
ENV WSDIR "/buhbase"
ENV CONNSTR "Srvr=serv1c;Ref=buhbase"
ENV PUBAPP "true"
ENV PUBODATA "true"
ENV SSL_VERIFYCLIENT "none"


COPY *ws_*.deb *common_*.deb *server_*.deb /
COPY 1c-site.conf /etc/apache2/sites-available/
COPY _1cws.load /etc/apache2/mods-available/
COPY index.html /var/www/html/
COPY default.vrd $PUB_ROOT/

RUN set -eux; \
  cd /; \
  dpkg -i *common_*.deb; \
  dpkg -i *ws_*.deb; \
  dpkg -i *server_*.deb; \
  rm *ws_*.deb *common_*.deb *server_*.deb; \
  mkdir -p $PUB_ROOT; \
# permissions
  chown -R root:root $PUB_ROOT; \
  chmod 0755 $PUB_ROOT; \
  find $PUB_ROOT -type d -print0 | xargs -0 chmod 0755; \
  find $PUB_ROOT -type f -print0 | xargs -0 chmod 0644; \
# enable 1c module
  a2enmod _1cws; \
# enable site
  a2dissite default-ssl; \
  a2ensite 1c-site

ENV SSL_CA /etc/ssl/certs/ca.pem
ENV SSL_CERT /etc/ssl/certs/u.pem
ENV SSL_KEY /etc/ssl/private/u.key

WORKDIR $PUB_ROOT

#VOLUME $PUB_ROOT

COPY site-prep /usr/local/bin/

# combine with http-uwc apache2-foreground
CMD ["sh", "-c", "site-prep && exec apache2-foreground"]
