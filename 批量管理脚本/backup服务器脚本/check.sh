#!/bin/bash
Date=$(date +%F)
flag_num=$(find /backup/ -type f -name "flag_$Date"|wc -l)

if [ $flag_num -eq 4 ]
   then
    echo "$Date Node servers package is normal" >/tmp/mail_$Date
   else
    echo "$Date Node servers package is not normal" >>/tmp/mail_$Date
fi
echo ============================================== >>/tmp/mail_$Date
count=$(find /backup/ -type f -name "flag_$Date"|xargs md5sum -c|grep -v OK|wc -l)
if [ $count -eq 0 ]
   then
    echo "$Date Backup server backup of all normal" >>/tmp/mail_$Date
   else
    echo "$Date Backup server backup is abnormal" >>/tmp/mail_$Date
    find /backup/ -type f -name "flag_$Date"|xargs md5sum -c|grep -v OK >>/tmp/m
ail_$Date
fi

mail -s "backup message $Date" linzyi1@163.com </tmp/mail_$Date

######delete local backup###
find /backup/ -type f -name "*.gz" -mtime +180|xargs rm -f
