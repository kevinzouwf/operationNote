#!/bin/sh
hostn=$(hostname|awk -F . '{print $1}')
time=$(date +%Y%m%d -d -1day)
logfile=/var/log/backup.log
backup () {
	if [ $hostn = api -o $hostn = passport  ];then
		filename=/usr/local/tomcat/passport/loginlog/login_log-$time
		[ -f $filename ] && mv $filename /backup/loginlog/
	elif [ $hostn = ytadmin01 -o $hostn = ytadmin02 ];then
		filename=/var/log/ytadmin/login_log-$time
		[ -f $filename ] && mv $filename /backup/loginlog/
	fi
}
rsync_fun () {
		/usr/bin/rsync -auvrtzopgP --progress --bwlimit=5000 --password-file=/etc/rsync.password /backup/ rsync_backup@10.44.152.16::${hostn}
		find /backup/ -type f -mtime +7|xargs rm -f
}
main () {
backup
rsync_fun
}
echo "===================$time==============" >> $logfile
main >> $logfile   2>&1

