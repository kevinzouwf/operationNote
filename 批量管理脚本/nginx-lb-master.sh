#!/bin/bash 
/usr/sbin/useradd -u 888 nginx -M -s /sbin/nologin 
ln -s /application/nginx-1.6.3/ /application/nginx 
/bin/mkdir /app/logs/ -p 
\cp /server/scripts/keepalived.conf /etc/keepalived/ 
/application/nginx/sbin/nginx 
/etc/init.d/keepalived start 
chkconfig keepalived on 
cat >>/etc/rc.local<<EOF  
#nginx+php-fpm by oldboy at 2011  
/application/nginx/sbin/nginx  
EOF  
 

