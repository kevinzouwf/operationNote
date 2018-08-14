#!/bin/sh
. /etc/init.d/functions

Dir="/application"
Softdir="/application/tools"

#Defined if config
function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
else
  action "$1" /bin/false
 exit 1
 fi
}

#Defined user&config 
function User () {
use=`grep "nginx" /etc/passwd|wc -l`
 if [ $use -ne 1 ];then
/usr/sbin/useradd -u 666 nginx  -s /sbin/nologin -M &>/dev/null
fi
[ ! -d $Softdir ] && /bin/mkdir $Softdir -p && \
cd $Softdir 

 Msg "mkdir&user"
}

#Defined Yusource
function Yum (){
yum -y install pcre pcre-devel openssl-devel gcc  && \
/usr/bin/wget http://nginx.org/download/nginx-1.6.3.tar.gz
   Msg "Yum source"
}

#Defined configure make make install
function Conf (){
tar xf nginx-1.6.3.tar.gz && \
cd nginx-1.6.3 && \
./configure \
--prefix=$Dir/nginx-1.6.3 \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_stub_status_module &>/dev/null && \

make >/dev/null && make install >/dev/null
  Msg "Nginx installed"
}

function Op (){
ln -s $Dir/nginx-1.6.3/ $Dir/nginx &>/dev/null
net=`netstat -lntup |grep 80|grep -v "grep" |wc -l`
[ "$net" -ne 0 ] && /usr/bin/killall `netstat -lntup |grep 80|awk -F '/' '{print $NF}'` &>/dev/null && $Dir/nginx/sbin/nginx || $Dir/nginx/sbin/nginx &>/dev/null
 Msg "Nginx start"
}

function main () {
User
Yum
Conf
Op
}
main
