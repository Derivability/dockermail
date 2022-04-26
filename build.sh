#!/bin/bash

BASEDIR=$(dirname $0)
D_COMPOSE="docker-compose -f ${BASEDIR}/docker-compose.yml"

read -p "Enter domain name: " DOMAIN

if [ -z "$DOMAIN" ]
then
	echo "No domain specified"
    exit 1
fi

if [ -f "${BASEDIR}/tls/${DOMAIN}/fullchain.pem" ]
then
    echo "No public certificate found at ${BASEDIR}/tls/${DOMAIN}/fullchain.pem"
    exit 2
fi

if [ -f "${BASEDIR}/tls/${DOMAIN}/privkey.pem" ]
then
    echo "No private certificate key found at ${BASEDIR}/tls/${DOMAIN}/privkey.pem"
    exit 3
fi

sed -i "s/__DOMAIN__/$DOMAIN/" src/postfix/configs/main.cf
sed -i "s/__DOMAIN__/$DOMAIN/" src/dovecot/configs/10-ssl.conf

$D_COMPOSE build