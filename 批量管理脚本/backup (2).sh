#!/bin/bash
. /etc/profile
IP=$(ifconfig eth0|awk -F '[: ]+' 'NR==2 {print $4}')
hostn=$(hostname|egrep -o '[a-z-]+')
Path="/data/$hostn/$IP"
time=$(date +%F)
##backup
[ ! -d $Path ] && mkdir $Path -p
cd / && \
tar zcf $Path/${hostn}_backup_$(date +%F).tar.gz etc/rc.local var/spool/cron/root server/scripts app/logs  && \
find $Path/ -type f -name "*$(date +%F).tar.gz" |xargs md5sum >$Path/flag_$(date +%F).txt

## backup to rsync server
rsync -az /data/$hostn/ rsync_backup@172.16.1.77::$hostn --password-file=/etc/rsync.password

##local delete before 3days age
find $Path/ -type f -name "*.tar.gz" -mtime +3 |xargs rm -f

