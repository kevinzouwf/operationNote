#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
mysql -uroot -psandow -S /data/3306/mysql.sock -e "show databases;"|egrep -v "Database|_schema|mysql"|sed -r 's#^(.*)#mysqldump -uroot -psandow -S /data/3306/mysql.sock -B \1|gzip >/server/backup/\1_$(date +%F).sql.gz#g'|bash
