#!/bin/sh
log_path=/var/log/nginx/
log_name=zabbix.log
pid_path=/usr/local/nginx/nginx.pid

mv $log_path$log_name /backup/nginx/${log_name}-$(date +%Y%m%d -d -1day)

kill -USR1 $(cat $pid_path)

