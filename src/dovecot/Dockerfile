FROM ubuntu:20.04

RUN apt update && apt upgrade -y &&\
apt install dovecot-imap -y

COPY configs/* /etc/dovecot/conf.d/

RUN useradd -u 5000 -g 5000 vmail -s /usr/sbin/nologin

CMD ["dovecot", "-F"]