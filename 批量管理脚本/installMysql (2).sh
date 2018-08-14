#!/bin/sh
. /etc/init.d/functions

Dir="/application"
SoftDir="/home/oldboy/tools"

function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
else
  action "$1" /bin/false
 exit 1
 fi
}

function addUser () {
useradd -M -s /sbin/nologin mysql && \
/bin/mkdir -p $Dir $SoftDir && \
Msg "addUser" 
}
function installMysql () {
cd $SoftDir && \
tar xf mysql-5.5.32-linux2.6-x86_64.tar.gz && \
mv mysql-5.5.32-linux2.6-x86_64 /application/mysql-5.5.32 && \
ln -s /application/mysql-5.5.32/ /application/mysql && \
/application/mysql/scripts/mysql_install_db --basedir=/application/mysql/ --datadir=/application/mysql/data/ --user=mysql && \
chown -R mysql.mysql /application/mysql/ && \
cp /application/mysql/support-files/my-small.cnf  /etc/my.cnf && \
Msg "installMysql"
}

function conf () {
sed -i 's#/usr/local/mysql#/application/mysql#g' /application/mysql/bin/mysqld_safe && \
/application/mysql/bin/mysqld_safe & >/dev/null && \
\cp /application/mysql/support-files/mysql.server /etc/init.d/mysqld && \
sed -i 's#/usr/local/mysql#/application/mysql#g' /etc/init.d/mysqld && \
/etc/init.d/mysqld  start && \
echo 'PATH="/application/mysql/bin:$PATH"' >>/etc/profile && \
source /etc/profile && \
Msg "conf"
}
function main () {
addUser
installMysql
conf
}
main








