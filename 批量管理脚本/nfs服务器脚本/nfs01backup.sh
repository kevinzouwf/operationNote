#!/bin/sh
IP=$(ifconfig eth1|awk -F '[ :]+' 'NR==2 {print $4}')
Path="/backup/$IP"
[ ! -d $Path ] && mkdir $Path -p

#tar to /backup
cd / && \
tar zcf $Path/conf_$(date +%F).tar.gz etc/rc.local var/spool/cron/root server/scripts/ && \
find $Path/ -type f -name "*$(date +%F).tar.gz"|xargs md5sum >$Path/flag_$(date +%F)

#backup to rysnc server
rsync -az /backup/ rsync_backup@172.16.1.41::backup/ --password-file=/etc/rsync.password

#local delete before 7 day ago
find $Path/ -type f -name "*.tar.gz" -mtime +7|xargs rm -f

