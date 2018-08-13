

linux  定时任务 crond 服务

crond是linux系统中用来定期执行命令或程序的一种 服务或软件。crond会定期（默认1分钟检查一次），检查系统中是否有要执行的任务工作。

秒级定时任务

	while true
	do
		echo “圭”
		sleep 1
	done

程序，磁盘上存在的文件
进程，正在运行的程序
守护进程，持续运行的程序， 存放在内在里。 $SHD

[sandow@sandow ~]$ ll /var/log/messages*
-rw-------  1 root root    6010 10月 27 10:33 /var/log/messages
-rw-------. 1 root root 1138377 10月  5 18:03 /var/log/messages-20151005
-rw-------. 1 root root  293049 10月  9 15:06 /var/log/messages-20151011
-rw-------  1 root root 1708237 10月 19 09:52 /var/log/messages-20151019
-rw-------  1 root root 2508974 10月 26 11:17 /var/log/messages-20151026
[sandow@sandow ~]$ ll /var/log/secure*
-rw-------  1 root root  6111 10月 27 09:30 /var/log/secure
-rw-------. 1 root root 13216 10月  5 18:11 /var/log/secure-20151005
-rw-------. 1 root root 20347 10月  9 18:41 /var/log/secure-20151011
-rw-------  1 root root 25247 10月 19 08:55 /var/log/secure-20151019
-rw-------  1 root root 33818 10月 25 09:56 /var/log/secure-20151026



at  适合执行一次就结束的调度任务命令（不会用到的）

chkconfig --list |grep atd



anacron 非7*24小时开机的服务器准备的。 （不需要啦啦啦）


crontab 一个命令，对应服务为 crond 定时任务

定时任务管理平台，》》》到不同的服务器

`crontab -l`  查看定时任务
         -e   修改  其它命令不怎么用的。( 检查语法）
         -u   指定用户

[sandow@sandow ~]$ ll `which crontab`
-rwsr-xr-x. 1 root root 51784 3月  30 2015 /usr/bin/crontab

定时任务在 /var/spool/cron/root


这是系统任务，不要 在这里写定时任务
[sandow@sandow ~]$ cat /etc/crontab 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun, mon, tue, wed, thu, fri, sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
  分 时 日 月 周  任务

    *  任意时间都，实际就是每的意思。
    -  区间，取值范围

		× 15-19 × × × 第天下午15-19整点执行任务	
    ，  间隔的，不连续的警卫
    /n  每隔n单们时间



/etc/init.d/crond status  要把crond启动起来。

周和日不同时用。

定时任务需要加注释
结尾不要有 >/dev/null 2>&1
/server/log 目录必须要存在才能出结果
定时任务中的路径一琮要绝对路径
crond服务必须启动
查看日志看是否备份成功。 `tail /var/log/cron`


每天晚上12点，打包站点目录/var/www/html备份到/data 目录下，

1,命令行测试成功
[root@sandow var]# tar zcf /data/html_$(date +%F).tar.gz ./www
[root@sandow var]# ls /data/
bb/                     html_2015-10-27.tar.gz  html_.tar.gz


2,命令写成脚本，测试成功

vim tar.sh
cd /var/www &&\
tar zcf /data/html_$(data +q%F).tar.gz ./html

/bin/sh /server/scripts/tar.sh
3, 定时任务

crontab -e

# tar html to data by yulei .....
00 00 * * * /bin/sh /server/scripts/tar.sh  >/dev/null 2>&1

crontab -l


&>/dev/null

find /data/ -type -f -name "html*.tar.gz" -mtime +7 |xargs rm -f


mail -s "hello,my love" 363349@qq.com <\/etc/hosts
mailq




set from=xiaxia_5321@163.com smtp=smtp.163.com smtp-auth-user=xiaxia_5321 smtp-auth-password=shanchuai123 smtp-auth=login

[root@oldboy ~]# mail -s "情书" xiaxia_5321@163.com < /etc/hosts
[root@oldboy ~]# mailq
15:09:20
老男孩教育 2015/10/27 15:09:20
[root@oldboy scripts]# cat /tmp/qingshu.txt 
Crond是linux系统中用来定期执行命令和或者指定程序任务的服务。
crond服务相当于生活中的闹钟，定时任务用来在指定的时间或者按一定的频率执行程序或任务。
[root@oldboy scripts]# cat send_qingshu.sh  
char="来自老男孩的情书"
mail -s "dear,$char" xiaxia_5321@163.com </tmp/qingshu.txt
[root@oldboy scripts]# crontab -l|tail -2   
####gei wo oldgirl's qingshu
00 07 * * * /bin/sh /server/scripts/send_qingshu.sh >/dev/null 2>&1

[root@oldboy scripts]# cat /server/scripts/tar1.sh 
mkdir -p /backup
cd / &&\
tar zcf /backup/conf_$(date +%F).tar.gz ./etc/rc.d/rc.local ./var/spool/cron/ ./etc/hosts
find /backup -type f -name "conf*.tar.gz" -mtime +3 -exec rm -f {} \;

老鸟谈生产场景删除文件及目录经验要领
http://oldboy.blog.51cto.com/2561410/1687300
15:26:45
老男孩教育 2015/10/27 15:26:45
   代码、配置变更发布流程：个人开发环境---办公测试环境--->IDC机房测试环境-->IDC正式环境(分组，灰度发布）。






98）
一个lamp的服务器，站点目录下所有文件均被植入了如下内容：
<script language=javascriptsrc=http://%4%66E%7F/x.js?google_ad=93x28_ad></script>
包括图片文件也被植入了，网站打开时就会调用这个地址，显示广告，造成的影响很恶劣。
实际解决方法：
 思路是：需要遍历所有目录所有文件，把以上被植入的内容删除掉。
法1：
[root@oldboy oldboy]#find . –type f –exec sed –i  ‘s#<script language=javascriptsrc=http://%4%66E%7F/x.js?google_ad=93x28_ad></script>
##g’ {} \;
法2：
[root@oldboy oldboy]# find . -type f -exec sed  -i '/^.*goo.*ad.*$/d' {} \;



99)文件删除生产场景案例解决实战：
Web服务器磁盘满故障深入解析 
http://oldboy.blog.51cto.com/2561410/612351
磁盘满案例
http://blogread.cn/it/article/6565?f=wb
问题：硬盘显示被写满，但是用du -sh /*查看时占用硬盘空间之和还远小于硬盘大小，即找不到硬盘分区是怎么被写满的。
（紧急求助，说生产线服务器硬盘满了。该删的日志都删掉了。可空间还是满的，情况危急啊。）
解答：
（1）出现上面问题原因：
在apache/tomcat服务在运行状态下，清空了运行服务的日志，这里是清理了当天或正在写入的apache及tomcat的日志文件，从而导致了上面问题。（有关原理细节见下文）
（2）引申下：
一般情况下，大多数服务（包括脚本）在运行时，是不能删除当前正在写入的日志文件的。这点请大家要记牢。
（3）本文的解决办法：
查找机器自身的服务，然后重起apache和tomcat。


100)如果向磁盘写入数据提示如下错误：No space left on device，通过df -h查看磁盘空间，发现没满，请问可能原因是什么？

解答：可能是inode数量被耗尽了
a df -i 查看是否耗尽了inode数量
b 企业工作中邮件临时队列/var/spool/clientmquene这里很容易被大量小文件占满导致No space left on device的错误。clientmquene目录只有安装了sendmail服务，才会有。
CentOS5.8默认就会装sendmail，CentOS6.6默认没有sendmail。




/etc/skel 存放用户 初始化环境变量目录
刚创建的用户的家目录的隐藏文件就是从此COPY过去

/etc/default/useradd 

使用useradd便会读取此文件，会跟据文件的设备创建用户
useradd 指定了参数，就村覆盖该文件的配置。


/etc/login.defs 


删除目录
1, 不要带r
2, 在passwd里注释
3, usermod -s /sbin/nologing

集中用户管理，AD。 LADP服务
密码，动态密码

passwd  --stdin

chage -E  -l 



















