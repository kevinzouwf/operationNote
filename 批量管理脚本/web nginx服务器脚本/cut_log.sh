#!/bin/sh
Path=/app/logs
Time=$(date +%F -d -1day)
cd $Path

/bin/mv www_access.log www_access_$Time.log
/bin/mv bbs_access.log bbs_access_$Time.log
/bin/mv blog_access.log blog_access_$Time.log

/application/nginx/sbin/nginx -s reload

########
find -type f -name ".log" -mtime +3|xargs rm -f
