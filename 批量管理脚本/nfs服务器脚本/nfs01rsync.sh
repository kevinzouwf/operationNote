#!/bin/sh

echo "oldboy" >/etc/rsync.password && \
chmod 600 /etc/rsync.password
#########
yum install inotify-tools -y

######
echo "00 00 * * * /bin/sh /server/scripts/nfs01backup.sh &>/dev/null" >>/var/spool/cron/root 

