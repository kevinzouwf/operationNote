#!/bin/sh
. /etc/init.d/functions
softDir='/usr/local/src'
Dir='/usr/local'
date=$(date +%Y%m%d)
function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
else
  action "$1" /bin/false
  exit 1
fi
}

function main () {
/bin/tar zxf $softDir/jdk-8u60-linux-x64.tar.gz -C /usr/local/
/bin/tar zxf $softDir/apache-tomcat-8.0.27.tar.gz -C /usr/local/
ln -s /usr/local/apache-tomcat-8.0.27 /usr/local/tomcat
ln -s /usr/local/jdk1.8.0_60 /usr/local/jdk
chown -R root.root /usr/local/jdk1.8.0_60
cp /etc/profile /etc/profile.bakcup_$date
sed -i '$a ## updata java and tomcat\nexport JAVA_HOME=/usr/local/jdk\nexport PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH\nexport CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar\nexport TOMCAT_HOME=/usr/local/tomcat' /etc/profile
source /etc/profile
}
echo $(date +%F_%H:%M) >>/var/log/shell.log 
main &>> /var/log/shell.log 
Msg "install tomcat"
