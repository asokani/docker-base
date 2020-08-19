#!/bin/bash
if [ -f /etc/secrets/letsencrypt/domain.csr ]
then
  SIGNED_CRT="$(mktemp --suffix=signed_crt)"
  sudo -u acme date >> /var/log/acme/acme_tiny.log
  sudo -u acme /usr/bin/python /opt/acme_tiny.py --account-key /etc/secrets-global/letsencrypt/letsencrypt-account.key --csr /etc/secrets/letsencrypt/domain.csr --acme-dir /var/app-cert/.well-known/acme-challenge > $SIGNED_CRT 2>> /var/log/acme/acme_tiny.log
  if [ -s $SIGNED_CRT ] # && /usr/bin/openssl verify $SIGNED_CRT
  then
    chmod 400 $SIGNED_CRT
    mv $SIGNED_CRT /etc/secrets/letsencrypt/signed.crt
  fi
fi
