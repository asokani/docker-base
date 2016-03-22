FROM mainlxc/ubuntu
MAINTAINER Asokani "https://github.com/asokani"

RUN apt-get update && \
  apt-get -y install postfix mailutils sqlite3 pwgen

# startup scripts
RUN mkdir -p /etc/my_init.d

# letsencrypt
ADD acme_tiny.py /opt/acme_tiny.py
RUN mkdir -p /var/log/acme && chown :acme /var/log/acme	
RUN mkdir -p /var/app-cert/.well-known/acme-challenge && \ 
	chown acme:www-user /var/app-cert/.well-known/acme-challenge && \
	chmod 750 /var/app-cert/.well-known/acme-challenge
ADD letsencrypt-startup.sh /etc/my_init.d/letsencrypt.sh
ADD letsencrypt-cron.sh /etc/cron.monthly/letsencrypt.sh

# ssh
RUN rm -f /etc/service/sshd/down

# mail
RUN sed -i 's/relayhost =/relayhost = postfix/g' /etc/postfix/main.cf
RUN sed -i 's/\/etc\/mailname,//g' /etc/postfix/main.cf
RUN echo "smtp_host_lookup = native\n" >> /etc/postfix/main.cf
RUN mkdir /etc/service/postfix
ADD postfix.sh /etc/service/postfix/run

EXPOSE 22

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
