安装Apache
1、下载安装
yum install zlib-devel -y
wget http://mirror.bit.edu.cn/apache/httpd/httpd-2.2.31.tar.gz
tar xf httpd-2.2.31.tar.gz 
cd httpd-2.2.31
./configure \
--prefix=/application/apache2.2.31 \
--enable-deflate \
--enable-expires \
--enable-headers \
--enable-modules=most \
--enable-so \
--with-mpm=worker \
--enable-rewrite
make
make install
ln -s /application/apache2.2.31/ /application/apache
ls -l /application/
2、启动服务
/application/apache/bin/apachectl start
netstat -lntup|grep httpd
3、配置基于域名的虚拟主机
cd /application/apache/conf/
vim httpd.conf 修改98行
ServerName 127.0.0.1:80

132 <Directory "/application/apache2.2.31/html">

378 Include conf/extra/httpd-mpm.conf
396 Include conf/extra/httpd-vhosts.conf

[root@web02 conf]# cd extra/
[root@web02 extra]# vim httpd-vhosts.conf 

<VirtualHost *:80>
    ServerAdmin oldboy@oldboyedu.com
    DocumentRoot "/application/apache2.2.31/html/www"
    ServerName www.etiantian.org

    ServerAlias etiantian.org
    ErrorLog "/app/logs/www-error_log"
    CustomLog "/app/logs/www-access_log" common
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin oldboy@oldboyedu.com
    DocumentRoot "/application/apache2.2.31/html/bbs"
    ServerName bbs.etiantian.org
    ErrorLog "/app/logs/bbs-error_log"
    CustomLog "/app/logs/bbs-access_log" common
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin oldboy@oldboyedu.com
    DocumentRoot "/application/apache2.2.31/html/blog"
    ServerName blog.etiantian.org
    ErrorLog "/app/logs/blog-error_log"
    CustomLog "/app/logs/blog-access_log" common
</VirtualHost>

[root@web02 extra]# mkdir -p /application/apache2.2.31/html/{www,bbs,blog}
[root@web02 extra]# echo www.etiantian.org >/application/apache2.2.31/html/www/index.html
[root@web02 extra]# echo bbs.etiantian.org >/application/apache2.2.31/html/bbs/index.html
[root@web02 extra]# echo blog.etiantian.org >/application/apache2.2.31/html/blog/index.html
[root@web02 extra]# mkdir /app/logs -p
[root@web02 extra]# /application/apache/bin/apachectl -t
Syntax OK
[root@web02 extra]# /application/apache/bin/apachectl graceful

[root@web02 extra]# curl www.etiantian.org                  
www.etiantian.org
[root@web02 extra]# curl bbs.etiantian.org
bbs.etiantian.org
[root@web02 extra]# curl blog.etiantian.org
blog.etiantian.org

（二）搭建PHP，本地不装MYSQL
1、安装依赖包并检查
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
yum install zlib-devel libxml2-devel libjpeg-devel freetype-devel libpng-devel gd-devel curl-devel libxslt-devel libmcrypt-devel mhash mhash-devel mcrypt openssl-devel -y
 
rpm -qa zlib-devel libxml2-devel libjpeg-turbo-devel freetype-devel libpng-devel gd-devel libcurl-devel libxslt-devel libmcrypt-devel mhash mhash-devel mcrypt openssl-devel
 
mkdir -p /home/oldboy/tools
cd /home/oldboy/tools
 
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
tar zxf libiconv-1.14.tar.gz
cd libiconv-1.14
./configure --prefix=/usr/local/libiconv
make
make install
cd ..
2、安装php(无需安装MySQL)
cd /home/oldboy/tools
tar xf php-5.5.30.tar.gz
cd php-5.5.30
./configure \
--prefix=/application/php5.5.30 \
--with-apxs2=/application/apache/bin/apxs \
--with-mysql=mysqlnd \
--with-iconv-dir=/usr/local/libiconv \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-safe-mode \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--with-curlwrappers \
--enable-mbregex \
--enable-mbstring \
--with-mcrypt \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--enable-short-tags \
--enable-zend-multibyte \
--enable-static \
--with-xsl \
--enable-ftp
make
make install
ln -s /application/php5.5.26/ /application/php
检查结果：
[root@web02 php-5.5.26]# ll /application/apache/modules/
总用量 30568
-rw-r--r-- 1 root root     9194 11月 10 20:37 httpd.exp
-rwxr-xr-x 1 root root 31285631 11月 10 23:51 libphp5.so
[root@web02 php-5.5.26]# grep libphp5.so /application/apache/conf/httpd.conf
LoadModule php5_module        modules/libphp5.so
[root@web02 php-5.5.26]# cp php.ini-production /application/php/lib/php.ini
3、配置httpd.conf
311行下增加：
AddType application/x-httpd-php .php .phtml
AddType application/x-httpd-php-source .phps
168行下增加：
DirectoryIndex index.php index.html
67行下增加
User www
Group www
建立用户：
useradd -u 513 -s /sbin/nologin www 
id www
 
/application/apache/bin/apachectl -t
/application/apache/bin/apachectl restart
检查PHP：
<?php
phpinfo();
?>
检查MySQL：
<?php
  $link_id=mysql_connect('db01.etiantian.org','wordpress','123456') or mysql_error();
    if($link_id){
           echo "mysql successful by oldboy training!";
     }
     else{
           echo mysql_error();
     }
?>




解决web集群多节点访问共享存储权限问题的方法

1、所有web集群节点的用户统一uid 例如888，用户最好也统一
针对我们当次的问题：
Apache server:
   useradd -u 888 -s /sbin/nologin -M www
   chown -R www.www /application/apache/html/
   chown -R www 挂载点
Nginx server:
   useradd -u 888 -s /sbin/nologin -M nginx
   chown -R nginx 挂载点
   chown -R nginx.nginx /application/nginx/html/
提示：
a、工作中所有文件644 目录755，用户和组都为root,上传的目录才web用户给写。
b、工作中所用软件和版本都要统一，不要同时使用apache和nginx。

2、在共享存储NFS上(其它存储也类似)
1、共享存储节点的用户统一uid 例如888，用户最好也统一
[root@nfs01 ~]# cat /etc/exports 
#data shared by oldboy at 20151110
/data 172.16.1.0/24(rw,sync,all_squash,anonuid=888,anongid=888)
[root@nfs01 ~]# useradd -u 888 -s /sbin/nologin -M www
[root@nfs01 ~]# /etc/init.d/nfs restart
检查：
[root@nfs01 ~]# cat /var/lib/nfs/etab 
/data   172.16.1.0/24(rw,sync,wdelay,hide,nocrossmnt,secure,root_squash,all_squash,no_subtree_check,secure_locks,acl,anonuid=888,anongid=888,sec=sys,rw,root_squash,all_squash)
共享目录授权
[root@nfs01 ~]# chown -R www.www /data/