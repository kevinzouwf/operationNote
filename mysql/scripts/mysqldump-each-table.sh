#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
MYUSER=root
MYPASS=623913
DIR=/backup
[ ! -d $DIR ] && mkdir $DIR
SOCKET=/data/3306/mysql.sock
MYCMD="mysql -u$MYUSER -p$MYPASS -S$SOCKET"
MYDUMP="mysqldump -u$MYUSER -p$MYPASS -S$SOCKET"
for database in `$MYCMD -e "show databases;"|egrep -v "Data|mysql|per|infor"`
do
$MYDUMP $database|gzip >/backup/${database}_$(date +%F).sql.gz
done
