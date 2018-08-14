#!/bin/bash
inotify_fun(){
hostn=$(hostname|egrep -o "[a-z-]+")
IEXCLUDE='(.*/*\.log|.*/*\.swp)$|^/tmp/src/mail/(2014|20.*/.*che.*)'
/usr/bin/inotifywait -mrq  --format '%w %f' --exclude ${IEXCLUDE}  -e modify,delete,create,move,attrib /uploads | \
while read line
do
  [ ! -e "$line" ] && \
  /usr/bin/rsync -az --delete --bwlimit=200 /uploads/ rsync_backup@172.16.1.77::uploads --password-file=/etc/rsync.password && continue
  /usr/bin/rsync -auvrtzopgP  --delete --progress --bwlimit=200 --password-file=/etc/rsync.password /uploads/ rsync_backup@172.16.1.77::uploads
done
}
function main () {
log_file=/app/logs/rsync_client.log
inotify_fun >>${log_file} 2>&1 &
}
main
