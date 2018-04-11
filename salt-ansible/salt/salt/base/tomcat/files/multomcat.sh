#!/bin/sh
. /etc/init.d/functions
RETVAL=$?
# tomcat实例目录
export CATALINA_BASE="/usr/local/tomcat/passport"
# tomcat安装目录
export CATALINA_HOME="/usr/local/tomcat"
# 可选
#export JVM_OPTIONS="-Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m"
export JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8
           -server -Xms2048m -Xmx2048m
           -XX:NewSize=512m -XX:MaxNewSize=512m 
           -XX:+DisableExplicitGC
           -Xloggc:$CATALINA_BASE/logs/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps
           -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$CATALINA_BASE/logs"
export CATALINA_OPTS="-Dcom.sun.management.jmxremote 
                      -Dcom.sun.management.jmxremote.authenticate=false 
                      -Djava.rmi.server.hostname=10.51.52.45 
                      -Dcom.sun.management.jmxremote.ssl=false 
                      -Dcom.sun.management.jmxremote.port=10053"
case "$1" in
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
