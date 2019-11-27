FROM phpmyadmin/phpmyadmin

# Install phpmyadmin 4.0
ENV M40_VERSION 4.0.10.20
ENV M40 phpMyAdmin-${M40_VERSION}-all-languages.tar.gz

COPY $M40 phpMyAdmin.tar.gz
RUN set -ex; \
  tar -xf phpMyAdmin.tar.gz -C /var/www; \
  rm phpMyAdmin.tar.gz; \
  mv /var/www/phpMyAdmin-${M40_VERSION}-all-languages /var/www/myadmin40; \
  rm -rf /var/www/myadmin40/setup/ /var/www/myadmin40/examples/ /var/www/myadmin40/composer.json; \
  sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin40/');@" /var/www/myadmin40/libraries/vendor_config.php; \
  sed -i "s@define('CONFIG_FILE'.*@define('CONFIG_FILE', CONFIG_DIR . 'config.user.inc.php');@" /var/www/myadmin40/libraries/vendor_config.php

# Enable SSL and /m40
RUN set -ex; \
  a2enmod ssl; \
  a2ensite default-ssl; \
  sed -i "/<VirtualHost/Ia ServerName myadmin.uwc.ufanet.ru:443" /etc/apache2/sites-available/default-ssl.conf; \
  sed -i "s@ssl-cert-snakeoil@u@g" /etc/apache2/sites-available/default-ssl.conf; \
  { echo ; \
    echo 'Alias /m40 /var/www/myadmin40'; \
    echo '<Directory /var/www/myadmin40>'; \
    echo 'Options None'; \
    echo 'AllowOverride None'; \
    echo 'DirectoryIndex index.php'; \
    echo 'Require all granted'; \
    echo '</Directory>'; \
    echo ''; \
    echo '<Directory /var/www/myadmin40/libraries>'; \
    echo 'Require all denied'; \
    echo '</Directory>'; } > _tmp_ttt; \
  sed -i "/DocumentRoot/Ir _tmp_ttt" /etc/apache2/sites-available/default-ssl.conf; \
  rm _tmp_ttt

EXPOSE 80/tcp
EXPOSE 443/tcp

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["apache2-foreground"]
