#!/bin/bash
/usr/sbin/useradd  rsync -M -s /sbin/nologin
/bin/mkdir /app/logs/ -p 
mkdir /data/uploads  /data/mysql /data/nfs /data/nginx /data/apache  -p 
chown -R rsync.rsync /data/
rsync --daemon 
echo "rsync --daemon" >>/etc/rc.local

