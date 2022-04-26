FROM ubuntu:20.04

RUN apt update && apt upgrade -y &&\
apt install postfix -y

COPY configs/main.cf /etc/postfix/main.cf

RUN postmap /postfix/vmaps/virtual_alias &&\
postmap /postfix/vmaps/virtual_mailbox &&\
groupadd -g 5000 vmail &&\
useradd -u 5000 -g 5000 vmail -s /usr/sbin/nologin

CMD ["postfix", "start-fg"]