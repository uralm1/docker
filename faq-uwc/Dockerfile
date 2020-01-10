FROM uralm1/httpd-uwc-llng:latest

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    mc \
    curl \
    php \
    php-curl \
    php-gd \
    php-xml \
  ; \
  rm -rf /var/lib/apt/lists/*

ENV DW_DIR /var/www/dokuwiki
ENV DW_URL https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz

COPY faq-site.conf /etc/apache2/sites-available/
COPY index.html /var/www/html/
COPY phpinfo.php /var/www/html/

RUN set -eux; \
  cd /var/www; \
  curl -SL $DW_URL | tar -xz; \
  mv dokuwiki* dokuwiki; \
  cp dokuwiki/.htaccess.dist dokuwiki/.htaccess; \
# permissions
  chown -R root:root $DW_DIR; \
  chmod 0755 $DW_DIR; \
  find $DW_DIR -type d -print0 | xargs -0 chmod 0755; \
  find $DW_DIR -type f -print0 | xargs -0 chmod 0644; \
  find $DW_DIR/bin -type f -print0 | xargs -0 chmod 0755; \
  chmod 0644 $DW_DIR/bin/.htaccess; \
  # data and data/tmp directories
  chown -R www-data:www-data $DW_DIR/data; \
  chown root:root $DW_DIR/data/.htaccess; \
  # lib/plugins
  chown -R www-data:www-data $DW_DIR/lib/plugins; \
  # conf
  chown -R www-data:www-data $DW_DIR/conf; \
  chown root:root $DW_DIR/conf/.htaccess; \
# enable site
  a2dissite default-ssl; \
  a2ensite faq-site

#ENV SSL_CERT /etc/ssl/certs/u.pem
#ENV SSL_KEY /etc/ssl/private/u.key

WORKDIR $DW_DIR

COPY site-prep /usr/local/bin/

# combine with httpd-uwc-llng apache2-foreground
CMD ["sh", "-c", "site-prep && exec apache2-foreground"]
