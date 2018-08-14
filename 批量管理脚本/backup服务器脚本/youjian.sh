#!/bin/sh

echo "set from=623913455@qq.com smtp=smtp.qq.com" >>/etc/mail.rc
echo "set smtp-auth-user=623913455 smtp-auth-password=LZyi623913">>/etc/mail.rc
echo "set smtp-auth=login">>/etc/mail.rc 
/etc/init.d/postfix start

########
echo "00 07 * * * /bin/sh /server/scripts/check.sh &>/dev/null" >>/var/spool/cron/root
