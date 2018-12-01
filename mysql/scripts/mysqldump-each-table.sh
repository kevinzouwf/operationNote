#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
USER=root
PASSWD=123456
SOCKET=/data/3306/mysql.sock
LOGIN="mysql -u$USER -p$PASSWD -S $SOCKET"
DUMP="mysqldump -u$USER -p$PASSWD -S $SOCKET -x -B -F -R"
DATABASE=$(mysql -u$USER -p$PASSWD -S $SOCKET -e "show databases;"|egrep -v 'chema|mysql|Database')

for db in $DATABASE
do
 TABLE=$($LOGIN -e "use $db; show tables;"|sed '1d')
 for tb in $TABLE
 do
 [ -d /server/backup/$db ] || mkdir -p /server/backup/$db
 $DUMP $db $tb |gzip >/server/backup/$db/${db}_${tb}_$(date +%F).sql.gz
 done
done
show tables from databases;
