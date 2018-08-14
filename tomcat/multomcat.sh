#!/bin/sh
. /etc/init.d/functions
RETVAL=$?
# tomcat实例目录
export CATALINA_BASE="/application/tomcat/tomcat$1"
# tomcat安装目录
export CATALINA_HOME="/application/tomcat"
# 可选
export JVM_OPTIONS="-Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m"
case "$2" in
start)
if [ -f $CATALINA_HOME/bin/startup.sh ];then
echo $"Start Tomcat"
$CATALINA_HOME/bin/startup.sh
fi
;;
stop)
if [ -f $CATALINA_HOME/bin/shutdown.sh ];then
echo $"Stop Tomcat"
$CATALINA_HOME/bin/shutdown.sh
fi
;;
*)
echo $"Usage: $0 {start|stop}"
exit 1
;;
esac
exit $RETVAL
