#!/bin/bash
. /etc/profile
. /etc/init.d/functions

hostn=$(/bin/hostname|egrep -o "[a-z-]+")
case "$hostn" in
	lb-master)
	yum install nginx-lb-master -y >/etc/null
	;;
	lb-backup)
	yum install nginx-lb-backup -y >/etc/null
	;;
	apache) 
	yum install lamp -y  >/etc/null
	/etc/init.d/rpcbind start >/etc/null
	mkdir -p /var/spool/cron/
	echo "00 3 * * * /bin/sh /server/scritpt/backup.sh &>/dev/null" >>/var/spool/cron/root
	/bin/sh /server/scripts/backup.sh 
	;;
	nginx) 
	yum install lnmp -y >/etc/null
	/etc/init.d/rpcbind start >/etc/null
	mkdir -p /var/spool/cron/ 
	echo "00 3 * * * /bin/sh /server/scritpt/backup.sh &>/dev/null" >>/var/spool/cron/root
	/bin/sh /server/scripts/backup.sh 
	;;
	nfs) 
	yum install nfs01 -y >/etc/null
	;;
	rsync)
	yum install backup -y >/etc/null
	;;
	*)
	exit
esac
