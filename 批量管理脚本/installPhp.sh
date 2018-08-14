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
function yumInstall () {
yum install zlib-devel libxml2-devel libjpeg-devel libiconv-devel -y  >/dev/null && \
yum install freetype-devel libpng-devel gd-devel curl-devel libxslt-devel -y  >/dev/null && \
yum install -y openssl-devel libtool libtool-ltdl-devel  libmcrypt-devel mhash mhash-devel mcrypt libxslt-devel >/dev/null && \
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo && \
/bin/mkdir $SoftDir -p && \
cd $SoftDir && \
/usr/bin/wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz && \
tar zxf libiconv-1.14.tar.gz  && \
cd libiconv-1.14 && \
./configure --prefix=/usr/local/libiconv >/dev/null && \
make >/dev/null && \
make install >/dev/null && \
 Msg "yumInstall"
}

function installPhp () {
cd $SoftDir && \
tar xf php-5.5.30.tar.bz2 && \
cd php-5.5.30 && \
./configure \
--prefix=/usr/local/php5.5.30 \
--with-mysql=mysqlnd \
--with-iconv-dir=/usr/local/libiconv \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-fpm \
--enable-mbstring \
--with-mcrypt \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-soap \
--enable-short-tags \
--enable-static \
--with-xsl \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-ftp >/dev/null && \
make >/dev/null && \
make install >/dev/null && \
ln -s /usr/local/php5.5.30/ /usr/local/php && \
cp php.ini-production /usr/local/php/lib/php.ini && \
 Msg "install Php"
}

function main () {
yumInstall
installPhp
}
main