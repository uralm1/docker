#!/bin/bash

docker run -d --restart unless-stopped --name myadmin \
  -h myadmin -p 443:443 \
  -v /etc/ssl/certs/uwc.ufanet.ru.pem:/etc/ssl/certs/u.pem \
  -v /etc/ssl/private/uwc.ufanet.ru-key.pem:/etc/ssl/private/u.key \
  -v /home/sv/conf_phpmyadmin/config.inc.php:/etc/phpmyadmin/config.user.inc.php \
  -v /home/sv/conf_phpmyadmin/config4.inc.php:/etc/phpmyadmin40/config.user.inc.php \
  uralm1/myadmin

# run php-fpm
#docker run --name myadmin-fpm -d -p 9000:9000 \
#  -v /home/sv/conf_phpmyadmin/config.inc.php:/etc/phpmyadmin/config.user.inc.php \
#  -v /var/www/m:/var/www/html \
#  phpmyadmin/phpmyadmin:fpm-alpine
