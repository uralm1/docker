FROM debian:buster-slim

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    vim \
    mc \
    apache2 \
    libapache2-mod-perl2 \
;
#  ; \
#  rm -rf /var/lib/apt/lists/*


ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

# tune apache2
RUN set -eux; \
#allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
  chmod 777 /var/www/html; \
# generically convert lines like
#   export APACHE_RUN_USER=www-data
# into
#   : ${APACHE_RUN_USER:=www-data}
#   export APACHE_RUN_USER
# so that they can be overridden at runtime ("-e APACHE_RUN_USER=...")
  sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS"; \
  \
#setup directories and permissions
  . "$APACHE_ENVVARS"; \
  for dir in \
    "$APACHE_LOCK_DIR" \
    "$APACHE_RUN_DIR" \
    "$APACHE_LOG_DIR" \
  ; do \
    rm -rvf "$dir"; \
    mkdir -p "$dir"; \
    chown "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
    chmod 777 "$dir"; \
  done; \
  \
# logs should go to stdout / stderr
  ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log"; \
  ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log"; \
  ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"; \
  chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"; \
  \
# smoke test
  apache2 -v; \
# prefer preforking
  a2dismod mpm_event; \
  a2enmod mpm_prefork; \
# enable SSL
  a2enmod ssl; \
  a2ensite default-ssl; \
  sed -i "s@ssl-cert-snakeoil@u@g" /etc/apache2/sites-available/default-ssl.conf; \
# enable perl
  a2enmod perl

COPY u.pem /etc/ssl/certs/
COPY u.key /etc/ssl/private/

# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL SIGWINCH

COPY apache2-foreground /usr/local/bin/
WORKDIR /var/www/html

EXPOSE 80 443

# same from httpd:2.4
CMD ["apache2-foreground"]
