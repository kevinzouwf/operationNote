#!/bin/sh

Dir=`ifconfig eth1|awk -F '[ :]+' 'NR==2{print $4}'`
Path=/backup/$Dir
[ ! -d $Path ] && mkdir $Path -p

#####backup 
mysqldump -uroot -p623913 -B -A --events -x|gzip>$Path/bak_$(date +%F).sql.gz

cd / && \
tar zcf $Path/conf_$(date +%F).tar.gz etc/rc.local var/spool/cron server/scripts 
find $Path/ -type f -name "*$(date +%F)*.gz"|xargs md5sum >$Path/flag_$(date +%F)

#########push##
cd /backup && \
rsync -az /backup/ rsync_backup@172.16.1.41::backup --password-file=/etc/rsync.password
###delete##
find -type f -name "*.gz" -mtime +7|xargs rm -f
