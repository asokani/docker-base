#!/bin/bash
if [ ! -f /etc/secrets/letsencrypt/signed.crt ]; then
	busybox httpd -f -p 80 -u www-user:www-user -h /var/app-cert &
	HTTP_PID=$!
	/etc/cron.weekly/letsencrypt
	kill $HTTP_PID
fi