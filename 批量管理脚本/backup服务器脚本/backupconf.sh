#!/bin/sh

mkdir -p /backup/{www,bbs,blog}

useradd rsync -u 555 -s /sbin/nologin -M && \
chown -R rsync.rsync /backup
###
echo "rsync_backup:oldboy" >/etc/rsync.password && \
chmod 600 /etc/rsync.password

######
/usr/bin/rsync --daemon  && \
echo "/usr/bin/rsync --daemon" >>/etc/rc.local
