FROM kylemanna/openvpn

COPY openvpn-db-log.pl /usr/local/bin/
#COPY pam-krb5-4.8.tar.gz /

RUN apk update && \
  apk add --no-cache perl perl-dbi perl-dbd-mysql mariadb-connector-c tzdata krb5 krb5-libs krb5-pkinit pam-krb5 && \
  chmod +x /usr/local/bin/openvpn-db-log.pl && \
# no need to build pam-krb5
  #tar -xf /pam-krb5-4.8.tar.gz -C / && \
  #rm -f /pam-krb5-4.8.tar.gz && \
# cleanup
  rm -rf /usr/local/share/man/* /var/cache/apk/* /var/cache/distfiles/*

RUN \
# setup /etc/krb5.conf
  { echo '[libdefaults]'; \
    echo ' default_realm = UWC.LOCAL'; \
    echo ' clockskew = 300'; \
    echo ' default_keytab_name = FILE:/etc/openvpn/krb5.keytab'; \
    echo ' dns_lookup_realm = false'; \
    echo ' forwardable = true'; \
    echo ' rdns = false'; \
    echo ' allow_weak_crypto = true'; \
    echo ' default_tgs_enctypes = arcfour-hmac-md5 des-cbc-crc des-cbc-md5'; \
    echo ' default_tkt_enctypes = arcfour-hmac-md5 des-cbc-crc des-cbc-md5'; \
    echo ' permitted_enctypes = arcfour-hmac-md5 des-cbc-crc des-cbc-md5'; \
    echo ; \
    echo '[realms]'; \
    echo ' UWC.LOCAL = {'; \
    echo '  kdc = plksrv1.uwc.local'; \
    echo '  kdc = plksrv2.uwc.local'; \
    echo ' }'; \
    echo ; \
    echo '[domain_realm]'; \
    echo ' .uwc.local = UWC.LOCAL'; \
    echo ; } > /etc/krb5.conf && \
# setup /etc/pam.d/openvpn1
  { echo '# PAM configuration for openvpn'; \
    echo 'auth required /usr/lib/security/pam_krb5.so fail_pwchange keytab=FILE:/etc/openvpn/krb5.keytab'; \
    echo 'account required pam_permit.so'; } > /etc/pam.d/openvpn1

# same as in origin
#CMD ["ovpn_run"]
