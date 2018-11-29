\section{用户管理}

### useradd
命令描述： create a new user or update default new user information 新增一个用户或者更新创建用户的默认信息，
在不给定`-D`会新增一个用户，这时会更新系统里几个文件，见下面用户的家目录里面的文件会从/etc/skel下面copy过来。

|文件|说明|
|:---|:---|
|/etc/passwd |User account information.|
|/etc/shadow |Secure user account information.|
|/etc/group |Group account information.|
|/etc/gshadow | Secure group account information.|
|/etc/default/useradd | Default values for account creation.|
|/etc/skel/  | Directory containing default files.|
|/etc/login.defs |  Shadow password suite configuration.|

    [root@sandow ~]# useradd -D
    GROUP=100
    HOME=/home
    INACTIVE=-1
    EXPIRE=
    SHELL=/bin/bash
    SKEL=/etc/skel
    CREATE_MAIL_SPOOL=yes

    [root@sandow ~]# cat /etc/default/useradd
    # useradd defaults file
    GROUP=100
    HOME=/home
    INACTIVE=-1
    EXPIRE=
    SHELL=/bin/bash
    SKEL=/etc/skel
    CREATE_MAIL_SPOOL=yes

命令参数：

* -c, --comment COMMENT，对此用户备注，可以为任意字符
* -e, --expiredate EXPIRE_DATE 指定用户账号过期天数，时间格式为 YYYY-MM-DD
* -f, --inactive INACTIVE 密码过期后的缓存天数
* -M 不创建家目录
* -s, --shell SHELL，指定用户登录的shell，默认为空，让系统自动选择shell。
* -g, --gid GROUP 指定组，组名或者GID都可以
* -u, --uid UID 指定uid，必须惟一而且非负，默认是用最小的ID
* -U, --user-group Create a group with the same name as the user, and add the user to this group.

语法：

       useradd [options] LOGIN
       useradd -D
       useradd -D [options]

举例：

    [root@sandow ~]# useradd yusanpao -g newgroup  # 也可以用 -g 888
    [root@sandow ~]# id yusanpao
    uid=503(yusanpao) gid=888(newgroup) groups=888(newgroup)


### userdel
命令描述：delete a user account and related files，删除用户以及相关文件
命令参数：

* -f --force 强制删除用户，即使当前用户在登录状态，同时删除用户的家目录和邮件
* -r --remove 删除用户家目录和邮件

命令语法

       userdel [options] LOGIN

举例：

### passwd
命令描述： passwd - update user’s authentication tokens，修改用户的密码
命令参数：

* --stdin
* -d 删除用户密码，仅对root有效
* -n 密码的最小生效时间
* -x 密码的最大生效时间
* -w 提醒用户密码过期
* -i 密码过期后使用的天数


### groupadd - create a new group

命令描述： 增加一个新组
命令参数：

* -g, --gid GID 指定组ID，这个数字必须是惟一的，如果有`-O`,那么这个参数可以不惟一

命令语法：

    groupadd [options] group

涉及的文件有：

* /etc/group  Group account information.
* /etc/gshadow Secure group account information.
* /etc/login.defs Shadow password suite configuration.

举例：

    [root@sandow ~]# groupadd -g 888 newgroup
    [root@sandow ~]# tail -1 /etc/group
    newgroup:x:888:
    [root@sandow ~]# tail -1 /etc/gshadow
    newgroup:!::

说明：
/etc/group 是一个文本文件，它定义了系统中组的信息，它的每行所包含的意思有 `group_name:passwd:GID:user_list`
user_list用“，”号分开

### groupdel

命令描述： delete a group , groupdel会个性group,gsandow两个文件，如果组中有用户，必须先删除用户再删除组
命令语法： groupdel group
举例：

```
    [root@sandow ~]# groupdel newgroup
    groupdel: cannot remove the primary group of user 'yusanpao'
    [root@sandow ~]# userdel -r yusanpao
    [root@sandow ~]# groupdel newgroup
    [root@sandow ~]# tail -1 /etc/group
    OP:x:502:
```



### 用户查询相关命令

**users** print the user names of users currently logged in to the current host

    $ users
    root root root yuyingcai yuyingcai
    id  users w who last lastlog groups

**who** show who is logged on

    $ who -H
    NAME     LINE         TIME             COMMENT
    yuyingcai pts/0        2015-11-10 01:24 (10.0.0.1)
    root     pts/2        2015-10-30 02:24 (10.0.0.1)
    root     pts/3        2015-10-30 02:52 (10.0.0.1)
    yuyingcai pts/4        2015-11-10 00:00 (10.0.0.1)
    root     pts/5        2015-11-10 00:35 (10.0.0.1)

**w** Show who is logged on and what they are doing.

```
 01:32:28 up  6:16,  6 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
yuyingca pts/0    10.0.0.1         01:24   26.00s  0.06s  0.00s man w
root     pts/1    10.0.0.1         01:32    0.00s  0.06s  0.00s w
root     pts/2    10.0.0.1         30Oct15  1:19m  0.29s  0.05s -bash
root     pts/3    10.0.0.1         30Oct15 10days  0.07s  0.00s man useradd
yuyingca pts/4    10.0.0.1         00:00    1:32m  0.04s  0.04s -bash
root     pts/5    10.0.0.1         00:35   56:25   0.11s  0.00s man userdel
```


**last**  show listing of last logged in users

参数

* -f file Tells last to use a specific file instead  of /var/log/wtmp.
* -t YYYYMMDDHHMMSS 显示出指定日期下的用户登录信息

```
$ last -5
root     pts/1        10.0.0.1         Tue Nov 10 01:32   still logged in
yuyingca pts/0        10.0.0.1         Tue Nov 10 01:24   still logged in
yuyingca pts/0        10.0.0.1         Tue Nov 10 01:24 - 01:24  (00:00)
yuyingca pts/0        10.0.0.1         Tue Nov 10 01:24 - 01:24  (00:00)
yuyingca pts/8        10.0.0.1         Tue Nov 10 00:53 - 01:24  (00:30)
```


**lastlog** reports the most recent login of all users or of a given user

```
$ lastlog -u root
Username         Port     From             Latest
root             pts/1    10.0.0.1         Tue Nov 10 01:32:26 +0800 2015
```

lastlog formats and prints the contents of the last login log /var/log/lastlog
Last  searches  back  through  the file /var/log/wtmp


### su
命令描述：run a shell with substitute user and group IDs 切换用户

* -, -l, --login make the shell a login shell, clears all envvars except for TERM, initializes HOME, SHELL,  USER,  LOGNAME and PATH

### 为普通用户授权
因root权力太大，所以一般会为普通用户授权，从而减少不必要的安全问题，我们可以用visudo来修改用户权限。
使用visudo，相当于修改/etc/sudoers这个文件，但是visudo可以检查语法，所以一般都会用visudo来配置用户权限
![权限](sudo.jpg)

    [root@sandow ~]# ll /etc/sudoers
    -r--r-----. 1 root root 4057 Oct 29 18:47 /etc/sudoers

visudo 里一些内容说明


|行数 |用途        |语法|
|:----|:----|:----|
|16G |用户(组，前加“%”）别名    | User_Alias ADMINS = jsmith, mikem, %yunying |
|13G |主机别名     | Host_Alias FILESERVERS = fs1, fs2  |
|    |           | Host_Alias MAILERVERS = fs1, fs2  |
|16G |运行角色别名 | Runas_Alias  OP = root  |
|23G |命令别名    | Cmnd_Alias SOFTWARE = /bin/rpm, /usr/bin/up2date, /usr/bin/yum |
|98G |设置用户权限 | ADMINS       fs1=(OP)  SOFTWARE |
|    |           | ADMINS       fs1=(OP)  NOPASSWD: SOFTWARE |
|    |           | yunying      fs1=(OP)  /usr/sbin/*, !/usr/sbin/halt |
|56G |  ssh -t   |  Defaults    requiretty|

多个命令可以用","隔开 用"!" 用来禁止使用某个命令，必须放到最后。

    [root@sandow db]# visudo -c
    /etc/sudoers: parsed OK

    [sandow@sandow ~]$ sudo -l
    User sandow may run the following commands on this host:
        (ALL) /user/sbin/useradd, (ALL) /ser/sbin/userdel

sudo
-l 检查被授予的权限

-K 清空时间戳,之后用sudo还需要输密码。


简历里要加上如下项目经验：
二、服务器用户权限管理改造方案与实施项目
1.在了解公司业务流程后，提出权限整改解决方案改进公司超级权限root泛滥的现状。
2.我首先撰写了方案后，给老大看，取得老大的支持后，召集大家开会讨论。
3.讨论确定可行后，由我负责推进实施。
4.实施后效果，公司的服务器权限管理更加清晰了（总结维护）。
5.制定了账号权限申请流程及权限申请表格。

项目实战：简历中的经验说明
三、服务器日志审计项目提出与实施
1.权限权限方案实施后，权限得到了细化控制，接下来进一步实施对所有用户日志记录方案。
2.通过sudo和syslog(rsyslog)配合实现对所有用户进行日志审计并将记录集中管理（发送到中心日志服务器）。
3.实施后让所有运维和开发的所有执行的sudo管理命令都有记录可查，杜绝了内部人员的操作安全隐患。


---

### 日志审计

任何用户，执行的任何操作记录，（录像，回放）
1。 sudo 配合 rsyslog 服务 , 进行日志审计，
2。 在bash解释器程序里嵌入一个监视器，让所有审计的用户记录其执行的命令相关信息。



日志相关：rsyslog,Awstats,flume logstash scribe kafka,storm，ELK(Elasticsearch+Logstash+Kibana)
http://oldboy.blog.51cto.com/2561410/775056
收集日志软件ELK

rsyslog


跳板机、堡垒机：

开源跳板机(堡垒机)Jumpserver部署详解
http://blog.51cto.com/zt/658
CrazyEye
http://3060674.blog.51cto.com/3050674/1700814


日志相关：rsyslog,Awstats,flume logstash scribe kafka,storm，ELK(Elasticsearch+Logstash+Kibana)

实际配置
Defaults        logfile=/var/log/sudo.log

\section{磁盘}
Jupyter Notebook
磁盘结构图
Last Checkpoint: 2015年10月30日
(autosaved)
Current Kernel Logo
Python 3
File
Edit
View
Insert
Cell
Kernel
Widgets
Help


### 磁盘管理
​
磁盘的外部
sync;sync;reboot
​
​
buffer写入缓冲区
cache读取缓存区
![io](IO.png)
​
服务 器 dell , hp, ibm.
企业级SAS硬盘，
​
​
不提供访问的可以用SATA盘。
​
千万不要用SATA磁盘来做在线高并发服务的数据存储或数据业务，
把磁盘从sata(raid5) 换成SAS（raid10)
​
磁盘的容量=
 一个磁道的容量=扇区数*512bytes
 一个盘面的容量=磁道数*扇区数*512bytes
 磁盘的容量=盘面数*一个盘面的容量
​
 磁盘的容量=磁头数*磁道数*扇区数*512bytes
          255 heads * 1044 cylinders * 63 sectors/track
​
​
[root@sandow ~]# fdisk -l
​
Disk /dev/sda: 8589 MB, 8589934592 bytes
255 heads, 63 sectors/track, 1044 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0001e36d
​
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          26      204800   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2              26         914     7134208   83  Linux
Partition 2 does not end on cylinder boundary.
/dev/sda3             914        1045     1048576   82  Linux swap / Solaris
​
### 磁盘读写原理
​
寻道很慢，一个磁道到另一个磁道
​
​
磁头读数据按照柱面进行的。
​
### raid0
​
raid 技术
redundant array of inexpensive disk  (disk array)
​
容量更大，性能更高，有冗余
​
![](raid.png)
​
​
​
LVM逻辑卷管理，最大用途是可以管理磁盘的容量，让磁盘分区可以随意放大或者缩小。
​
RAID0  又称为Stripe条带化，它在所有raid级别中有最高的存储性能。
至少有1块物理磁盘，一般用来做RAID的不同磁盘大小。最好 一样。
生产中使用单盘，要做成RAID0。否则可能无法使用
​
​
### raid1
mirror 或mirroring镜像。至少两块盘。做好raid1，的容量为最小那块硬盘的容量。存储时同时写入两块磁盘，实现了数据完整备份，但相对降低了写入性能。 听说可以并发。
​
### raid 5
RAID 5是一种存储性能、数据安全和存储成本兼顾的存储解决方案。
最少三块盘。采用基偶校验
RAID 5是一种存储性能、数据安全和存储成本兼顾的存储解决方案。
RAID 5是把数据和相对应的奇偶校验信息存储到组成RAID5的各个磁盘上，并且奇偶校验信息和相对应的数据分别存储于不同的磁盘上。当RAID5的一个磁盘数据发生损坏后，利用剩下的数据和相应的奇偶校验信息去恢复被损坏的数据。
​
### raid10

​

\section{buffer cache区别}
cache:  一般 用于读操作， 读缓存。提高数据读取速度

CPU： L1 L2 L3  ： CPU cache 位于内存与CPU之间。 CPU把内存中的数据读取到cache上，然后下次从cache读取，这样比读内存更快。
buffer 缓冲区，用于提高速度不同传输速度。 cpu把数据写到内存的磁盘缓存区 然后系统启动一个进程（pd flash）把内存的数据写到硬盘。
其目的都是解决速度不一致的问题。 有的太快，有的太慢。他们之前进行IO操作时，需要用buffer cache来提高IO操作，首先cache来读缓存，buffer写缓冲，写到离目的地最近的地方，然后再写到目的地。


浏览器第一次必须获取到资源后，然后根据返回的信息来告诉如何缓存资源，可能采用的是强缓存，也可能告诉客户端浏览器是协商缓存，这都需要根据响应的header内容来决定的。

第一次请求

\begin{figure}[!ht]
    \centering    
     \caption{\label{Fig:async} Asynchronous I/O model}
    \includegraphics[width=0.8\textwidth]{./images/firstRequest.png}  
\end{figure}

下一次请求

\begin{figure}[!ht]
    \centering    
     \caption{\label{Fig:async} Asynchronous I/O model}
    \includegraphics[width=0.8\textwidth]{./images/nextRequest.png}  
\end{figure}

\subsection{强缓存}

运维了解到此基础就OK, 需要了解更深可以查看网上资源

https://www.zhihu.com/question/20790576

https://www.cnblogs.com/wonyun/p/5524617.html

\section{linux系统命令}

用户权限分配

用户/组   主机    可以切换的用户角色	命令
root     ALL=     (ALL)			ALL
User_Alias  Host_Alias    Runas_Aliase  Cmad_Alias  
mikem
%groupname

