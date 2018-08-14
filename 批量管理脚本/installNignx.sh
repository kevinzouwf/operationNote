#!/bin/sh
. /etc/init.d/functions

Dir="/application"
SoftDir="/home/sandow/tools"

function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
else
  action "$1" /bin/false
 exit 1
 fi
}

function User () {
use=`grep "nginx" /etc/passwd|wc -l`

[ -d $SoftDir ] ||/bin/mkdir $SoftDir -p && \
cd $SoftDir && \
if [ $use -ne 1 ];then
	/usr/sbin/useradd -u 888 nginx -s /sbin/nologin -M &>/dev/null
fi
 Msg "mkdir&user"
}

function installNginx () {
yum -y install pcre-devel openssl-devel >/dev/null && \
cd $SoftDir && \
/usr/bin/wget http://nginx.org/download/nginx-1.6.3.tar.gz && \
/bin/tar zxf nginx-1.6.3.tar.gz && \
cd nginx-1.6.3 && \
./configure --prefix=/application/nginx-1.6.3 \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_stub_status_module &>/dev/null  ||
make >/dev/null && make install >/dev/null && \
  Msg "make and install"
}

#function deployN () {
#ln -s $Dir/nginx-1.6.3/ $Dir/nginx &>/dev/null
#}
function deployN () {
ln -s $Dir/nginx-1.6.3/ $Dir/nginx &>/dev/null && \
cat >/application/nginx/conf/nginx.conf <<EOF
worker_processes  1;  
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on; 
    access_log /app/logs/access.log;
    error_log /app/logs/error.log;
    keepalive_timeout  65; 
    server {
        listen       80; 
        server_name  www.etiantian.org;
            root   /data/www/www;
		location / { 
            index  index.php index.html index.htm;
        }   
        location ~ .*\.(php|php5)?$ {
            fastcgi_pass  127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
        }  
    }    
    server {
        listen       80; 
        server_name  bbs.etiantian.org;
        root   /data/www/bbs;
        location / { 
            index  index.php index.html index.htm;
        }   
        location ~ .*\.(php|php5)?$ {
            fastcgi_pass  127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
        }  
    }   
    server {
        listen       80; 
        server_name  blog.etiantian.org;
        root /data/www/blog;
        location / { 
            index  index.php index.html index.htm;
        }   
        location ~ .*\.(php|php5)?$ {
            fastcgi_pass  127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
        }   
    }   
}
EOF
}
function startN (){
/bin/mkdir -p /app/logs && \
/bin/mkdir -p /data/www/www /data/www/blog /data/www/bbs && \
chown -R nginx.nginx /data
net=`netstat -lntup |grep 80|grep -v "grep" |wc -l`
[ "$net" -ne 0 ] && /usr/bin/killall `netstat -lntup |grep 80|awk -F '/' '{print $NF}'` &>/dev/null && $Dir/nginx/sbin/nginx || $Dir/nginx/sbin/nginx &>/dev/null
 Msg "Nginx start"
}
function main () {
User
installNginx
deployN
startN
}
main
