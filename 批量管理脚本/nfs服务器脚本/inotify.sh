#!/bin/bash
/usr/bin/inotifywait -mrq  --format '%w%f' -e create,close_write,delete /data \
|while read file
do
  cd /data &&
  rsync -az ./www/ --delete rsync_backup@172.16.1.41::www --password-file=/etc/rsync.password
  rsync -az ./bbs/ --delete rsync_backup@172.16.1.41::bbs  --password-file=/etc/rsync.password
  rsync -az ./blog/ --delete rsync_backup@172.16.1.41::blog --password-file=/etc/rsync.password
done
