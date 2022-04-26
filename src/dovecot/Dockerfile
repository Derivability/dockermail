FROM ubuntu:20.04

RUN apt update && apt upgrade -y &&\
apt install dovecot-imapd -y

COPY configs/* /etc/dovecot/conf.d/

RUN groupadd -g 5000 vmail && \
useradd -u 5000 -g 5000 vmail -s /usr/sbin/nologin

CMD ["dovecot", "-F"]