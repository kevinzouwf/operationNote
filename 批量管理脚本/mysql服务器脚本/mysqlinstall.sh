#!/bin/sh
. /etc/init.d/functions


Soft=/application
Softdir=/application/tools

#Defined if config
function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
else
  action "$1" /bin/false
 exit 1
 fi
}

#Defined user&mkdir
function User () {
use=`grep "mysql" /etc/passwd|wc -l`
if [ $use -ne 1 ];then
/usr/sbin/useradd -u 666 mysql  -s /sbin/nologin -M &>/dev/null
fi

[ -d $Softdir ] || /bin/mkdir $Softdir -p && \
cd $Softdir && \

 Msg "mkdir&useradd"
}

#Defined Wget source
#function Wget (){
#/usr/bin/wget -q mysql-5.5.32-linux2.6-x86_64.tar.gz
  # Msg "Wget source"
#}

##Defined configure make && make install
function Conf (){
[ -d $Soft ] || /bin/mkdir -p $Soft 
tar xf mysql-5.5.32-linux2.6-x86_64.tar.gz && \
/bin/mv mysql-5.5.32-linux2.6-x86_64 $Soft/mysql-5.5.32 && \
ln -s $Soft/mysql-5.5.32/ $Soft/mysql && \
$Soft/mysql/scripts/mysql_install_db \
--basedir=$Soft/mysql/ \
--datadir=$Soft/mysql/data/ \
--user=mysql  &>/dev/null

make >/dev/null && make install >/dev/null && \
  Msg "mysql installed"
}

#Defined mysql start
function Start () {
chown -R mysql.mysql $Soft/mysql/ && \
/bin/cp $Soft/mysql/support-files/my-small.cnf  /etc/my.cnf && \
sed -i 's#/usr/local/mysql#$Soft/mysql#g' $Soft/mysql/bin/mysqld_safe $Soft/mysql/support-files/mysql.server && \
/bin/cp $Soft/mysql/support-files/mysql.server /etc/init.d/mysqld

echo PATH="/application/mysql/bin:$PATH" >>/etc/profile && \
source /etc/profile

/etc/init.d/mysqld start && \
echo "/etc/init.d/mysqld start" >>/etc/rc.local

 Msg "Mysql start"
}
#Defined mysql 
function Mysqladmin () {
mysqladmin -uroot password 623913
Msg "Mysqladmin config"
}

function main () {
User
#Wget
Conf
Start
Mysqladmin
}
main
