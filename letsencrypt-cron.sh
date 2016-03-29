#!/bin/bash
SIGNED_CRT="$(mktemp)"
INTERMEDIATE="$(mktemp)"
sudo -u acme date >> /var/log/acme/acme_tiny.log
sudo -u acme /usr/bin/python /opt/acme_tiny.py --chain-file $INTERMEDIATE --account-key /etc/secrets-global/letsencrypt/letsencrypt-account.key --csr /etc/secrets/letsencrypt/domain.csr --acme-dir /var/app-cert/.well-known/acme-challenge > $SIGNED_CRT 2>> /var/log/acme/acme_tiny.log
if [ -s $SIGNED_CRT ] && /usr/bin/openssl verify -CAfile $INTERMEDIATE $SIGNED_CRT
then
    cat $SIGNED_CRT $INTERMEDIATE > /etc/secrets/letsencrypt/chained.pem
    chmod 400 $SIGNED_CRT $INTERMEDIATE /etc/secrets/letsencrypt/chained.pem
    mv $INTERMEDIATE /etc/secrets/letsencrypt/intermediate.pem
    mv $SIGNED_CRT /etc/secrets/letsencrypt/signed.crt
fi
rm $INTERMEDIATE $SIGNED_CRT
