FROM uralm1/httpd-uwc-llng:latest

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    #mc \
    curl \
    php \
    php-curl \
    php-gd \
    php-xml \
  ; \
  rm -rf /var/lib/apt/lists/*

ENV DW_DIR /dokuwiki
ENV DW_URL https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz

COPY faq-site.conf /etc/apache2/sites-available/
COPY index.html /var/www/html/
#COPY phpinfo.php /var/www/html/

COPY plugins.tar.gz /
COPY uwc.tar.gz /

RUN set -eux; \
  cd /; \
  curl -SL $DW_URL | tar -xz; \
  mv ${DW_DIR}* $DW_DIR; \
  cp $DW_DIR/.htaccess.dist $DW_DIR/.htaccess; \
  { echo ; \
    echo 'php_value upload_max_filesize 16M'; \
    echo 'php_value post_max_size 16M'; } >> $DW_DIR/.htaccess; \
# add plugins
  tar -xf /plugins.tar.gz -C $DW_DIR/lib/plugins/; \
  rm /plugins.tar.gz; \
# add uwc template
  tar -xf /uwc.tar.gz -C $DW_DIR/lib/tpl/; \
  rm /uwc.tar.gz; \
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
# activate rewriting
  a2enmod rewrite; \
  sed -i "s/\$conf\['userewrite'\] \+= \+[012];/\$conf['userewrite'] = 1;/" $DW_DIR/conf/dokuwiki.php; \
# copy defaults to runtime use
  cp -a $DW_DIR/conf $DW_DIR/conf.dist; \
  cp -a $DW_DIR/data $DW_DIR/data.dist; \
# tune php
  sed -i "s/^upload_max_filesize \+=.*/upload_max_filesize = 16M/" /etc/php/7.3/apache2/php.ini; \
  sed -i "s/^post_max_size \+=.*/post_max_size = 16M/" /etc/php/7.3/apache2/php.ini; \
# enable site
  a2dissite default-ssl; \
  a2ensite faq-site

#ENV SSL_CERT /etc/ssl/certs/u.pem
#ENV SSL_KEY /etc/ssl/private/u.key

WORKDIR $DW_DIR

VOLUME $DW_DIR/data
VOLUME $DW_DIR/conf

COPY site-prep /usr/local/bin/

# combine with httpd-uwc-llng apache2-foreground
CMD ["sh", "-c", "site-prep && exec apache2-foreground"]
