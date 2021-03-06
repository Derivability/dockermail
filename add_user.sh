#!/bin/bash

BASEDIR=$(dirname $0)
D_COMPOSE="docker-compose -f ${BASEDIR}/docker-compose.yml"

if [ -n "$(${D_COMPOSE} ps -q)" ]
then
    D_EXEC="${D_COMPOSE} exec"
else
    D_EXEC="${D_COMPOSE} run"
fi

function read_pass() {
        stty_orig=$(stty -g)
        stty -echo
        read -p "$1" password
        stty ${stty_orig}
        echo "${password}"
}

read -p "Enter domain name: " DOMAIN
read -p "Enter username: " USERNAME

if [ -n "$(grep '${USERNAME}@${DOMAIN}' ${BASEDIR}/dovecot_users/dovecot_passwd)" ]
then
    echo "User '${USERNAME}' already exists in domain '${DOMAIN}'"
    exit 1
fi

PASSWORD=$(read_pass "Enter user password: ")

HASH=$(${D_EXEC} dovecot doveadm pw -s SHA512-CRYPT -p ${PASSWORD})

echo "${USERNAME}@${DOMAIN}:${HASH}" >> ${BASEDIR}/dovecot_users/dovecot_passwd
echo "${USERNAME}@{DOMAIN} ${USERNAME}" >> ${BASEDIR}/postfix_vmaps/virtual_alias
echo "${USERNAME} ${DOMAIN}/${USERNAME}/" >> ${BASEDIR}/postfix_vmaps/virtual_mailbox

${D_EXEC} postfix postmap /postfix/vmaps/virtual_alias /postfix/vmaps/virtual_mailbox
