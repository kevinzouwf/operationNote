#!/bin/sh
. /etc/init.d/functions

#Defined if config
function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
else
  action "$1" /bin/false
 exit 1
 fi
}

####
function Rsync () {
echo "oldboy" >/etc/rsync.password && \
chmod 600 /etc/rsync.password
 Msg "rsync config ok"
}

####
function Backup () {
echo "00 00 * * * /bin/sh /server/scripts/mysqlpush.sh &>/dev/null" >>/var/spool/cron/root 
 Msg "mysqldump to backup"
}


function  main {
Rsync
Backup
}
main

