#!/bin/sh 

i_install_port=3306 
i_db_base_dir=/data/${i_install_port} 
i_db_data_dir=$i_db_base_dir/data 
i_root=root
i_root_pwd=123456 
i_install_log=/tmp/mysql_install_`date +'%F_%T'`.log

i_step=0
#i_step=$(($i_step+1))
#i_step=`expr $i_step + 1`
#i_step=`echo $i_step + 1|bc`


function mysql_config_info
{ 
  echo "*******************************************************" | tee -a $i_install_log
  echo "**                MySQL默认配置信息                    " | tee -a $i_install_log
  echo "**软件安装路径   ：/opt/mysql/                         " | tee -a $i_install_log
  echo "**软件包位置     ：/root/tools/                        " | tee -a $i_install_log
  echo "**软件包名       ：mysql-5.5.32_bin_x86_64.tar.gz      " | tee -a $i_install_log
  echo "**实例base目录   ：$i_db_base_dir                      " | tee -a $i_install_log
  echo "**实例data目录   ：$i_db_data_dir                      " | tee -a $i_install_log
  echo "**实例默认端口   ：$i_install_port                     " | tee -a $i_install_log
  echo "**初始化root密码 ：$i_root_pwd                         " | tee -a $i_install_log
  echo "*******************************************************" | tee -a $i_install_log
}

function mysql_flag_info
{ 
  echo "*******************************************************" | tee -a $i_install_log
  echo "**                操作选项                             " | tee -a $i_install_log 
  echo "** 0 退出安装                                          " | tee -a $i_install_log 
  echo "** 1 默认配置安装                                      " | tee -a $i_install_log
  echo "** 2 设置实例base目录                                  " | tee -a $i_install_log  
  echo "** 3 设置实例data目录                                  " | tee -a $i_install_log  
  echo "** 4 设置实例默认端口                                  " | tee -a $i_install_log 
  echo "** 5 初始化root密码                                    " | tee -a $i_install_log 
  echo "** 6 查看参数配置                                      " | tee -a $i_install_log 
  echo "** 7 操作选项帮助                                      " | tee -a $i_install_log 
  echo "** 8 完成参数设置，准备开始安装                        " | tee -a $i_install_log 
  echo "** 9 老男孩Linux培训咨询                               " | tee -a $i_install_log 
  echo "*******************************************************" | tee -a $i_install_log
} 

function oldboy_linux_train 
{ 
  echo "#####################################################" | tee -a $i_install_log
  echo "# 老男孩linux运维实战培训中心                        " | tee -a $i_install_log
  echo "# 培训咨询：QQ: 41117397  70271111 41117483 80042789 " | tee -a $i_install_log
  echo "# 培训电话：18600338340 18911718229                  " | tee -a $i_install_log
  echo "# 老男孩老师 QQ:49000448 31333741                    " | tee -a $i_install_log
  echo "# 网站地址：http://www.etiantian.org                 " | tee -a $i_install_log
  echo "# 老男孩博客:http://oldboy.blog.51cto.com            " | tee -a $i_install_log
  echo "# 老男孩交流群  246054962208160987 226199307 44246017" | tee -a $i_install_log 
  echo "# 网站运维交流群：114580181 45039636 37081784        " | tee -a $i_install_log
  echo "#####################################################" | tee -a $i_install_log
}

# 老男孩Linux培训咨询，欢迎大家
oldboy_linux_train 

# 配置参数
mysql_config_info 

# 操作选项帮助
mysql_flag_info 

# 参数配置,输入9，结束配置
while [ 1 = 1 ] 
do 
  read -p "【Enter:[0-9]】" i_install_flag
  case "$i_install_flag" in 
    0)
      echo "**您输入的是：$i_install_flag 退出安装" | tee -a $i_install_log
      exit 0
    ;;
    1)
      echo "**您输入的是：$i_install_flag 默认配置安装" | tee -a $i_install_log
    ;;
    2)
      echo "**您输入的是：$i_install_flag 设置实例base目录" | tee -a $i_install_log
      read -p "【设置实例base目录】：" i_db_base_dir
      echo "-->实例base目录为:$i_db_base_dir" | tee -a $i_install_log
    ;;  
    3)
      echo "**您输入的是：$i_install_flag 设置实例data目录" | tee -a $i_install_log
      read -p "【设置实例data目录】：" i_db_data_dir
      echo "-->实例data目录为:$i_db_data_dir" | tee -a $i_install_log
    ;;
    4)
      echo "**您输入的是：$i_install_flag 设置实例默认端口"  | tee -a $i_install_log 
      read -p "【输入端口[1000-65535]】：" i_install_port 
      echo "-->新端口号为:$i_install_port" | tee -a $i_install_log
    ;;
    5)
      echo "**您输入的是：$i_install_flag 初始化root密码" | tee -a $i_install_log 
      read -p "【初始化root密码】：" i_root_pwd
      echo "-->初始化root密码为：$i_root_pwd" | tee -a $i_install_log
    ;;
    6)
      echo "**您输入的是：$i_install_flag 查看参数配置" | tee -a $i_install_log 
      mysql_config_info 
    ;;
    7)
      echo "**您输入的是：$i_install_flag 操作选项帮助" | tee -a $i_install_log 
      mysql_flag_info 
    ;;
    8)
      echo "**您输入的是：$i_install_flag 完成参数设置，准备开始安装" | tee -a $i_install_log 
      break 
    ;;
    9)
      echo "**您输入的是：$i_install_flag  老男孩Linux培训咨询" | tee -a $i_install_log 
      oldboy_linux_train 
    ;;
    *)
      echo "**您输入的是：$i_install_flag Error!!" | tee -a $i_install_log 
      mysql_flag_info 
    ;;
  esac 
done 
# End while [ 1 = 1 ]


# 安装前，最后检查配置参数 
echo "-->安装前，最后检查配置参数，请仔细核对信息！" | tee -a $i_install_log
mysql_config_info 
read -p "【Enter：Y[y]:开始一键安装 其他:退出】" i_install_flag

if [ $i_install_flag = "Y" -o $i_install_flag = "y" ]
then 
  echo "-->Step $i_step,`date +'%F_%T'`,MySQL一键安装开始..." | tee -a $i_install_log
  i_step=$(($i_step+1))
else
  echo "退出安装" | tee -a $i_install_log
  exit 0
fi

#echo "-->!! 对不起,还未准备好一键安装,您太着急了!!"  

# 开始一键安装，若存在安装包，则开始，否则退出。
if [ -f /root/tools/mysql-5.5.32_bin_x86_64.tar.gz ] 
then 
  echo "-->Step $i_step,`date +'%F_%T'`,安装软件包." | tee -a $i_install_log
  i_step=$(($i_step+1))
  cd /root/tools
  tar -zxf mysql-5.5.32_bin_x86_64.tar.gz -C /opt 
  cd /opt
  ln -s mysql-5.5.32 mysql 
  ls -l /opt
  echo "export PATH=/opt/mysql/bin:\$PATH" >> /etc/profile 
  tail -1 /etc/profile 
  source /etc/profile
  echo $PATH | tee -a $i_install_log
  
  # 创建用户和组
  echo "-->Step $i_step,`date +'%F_%T'`,创建用户和组." | tee -a $i_install_log
  i_step=$(($i_step+1))
  groupadd mysql 
  useradd mysql -s /sbin/nologin -M -g mysql 
  
  # 创建数据目录 
  echo "-->Step $i_step,`date +'%F_%T'`,创建实例目录,属主为mysql." | tee -a $i_install_log
  i_step=$(($i_step+1))
  mkdir -p $i_db_data_dir
  mkdir -p $i_db_base_dir/binlog 
  mkdir -p /opt/mysql-5.5.32/data 
  chown -R mysql:mysql /opt/mysql-5.5.32
  chmod 1777 /tmp
  chown -R mysql:mysql $i_db_data_dir 
  
  # 若创建失败，则退出 
  if [ ! -d $i_db_base_dir ]
  then 
    echo "-->Step $i_step,`date +'%F_%T'`,实例目录创建失败,退出安装." | tee -a $i_install_log
    i_step=$(($i_step+1))
    echo "!!! Mysql data dir $i_db_base_dir not exist!" | tee -a $i_install_log
    exit 1
  fi
  
  ###############################################################
  # 一键生成mysql配置文件 BEGIN
  ###############################################################
  echo "-->Step $i_step,`date +'%F_%T'`,一键生成mysql配置文件 ${i_db_base_dir}/my.cnf ." | tee -a $i_install_log
  i_step=$(($i_step+1))
  cat > $i_db_base_dir/my.cnf << EOF
[client]
port            = $i_install_port
socket          = $i_db_base_dir/mysql.sock

[mysql]
no-auto-rehash

[mysqld]
user    = mysql
port    = $i_install_port
socket  = $i_db_base_dir/mysql.sock
basedir = /opt/mysql
datadir = $i_db_data_dir
open_files_limit = 1024
back_log = 600
max_connections = 800
max_connect_errors = 3000
table_cache = 614
external-locking = FALSE
max_allowed_packet =8M
sort_buffer_size = 1M
join_buffer_size = 1M
thread_cache_size = 100
thread_concurrency = 2
query_cache_size = 2M
query_cache_limit = 1M
query_cache_min_res_unit = 2k
#default_table_type = InnoDB
thread_stack = 192K
#transaction_isolation = READ-COMMITTED
tmp_table_size = 2M
max_heap_table_size = 2M
long_query_time = 1
#log_long_format
#log-error = $i_db_base_dir/error.log
#log-slow-queries = $i_db_base_dir/slow.log
pid-file = $i_db_base_dir/mysql.pid
log-bin =  $i_db_base_dir/binlog/mysql-bin
relay-log = $i_db_base_dir/binlog/relay-bin
relay-log-info-file = $i_db_base_dir/binlog/relay-log.info
binlog_cache_size = 1M
max_binlog_cache_size = 1M
max_binlog_size = 2M
expire_logs_days = 7
key_buffer_size = 16M
read_buffer_size = 1M
read_rnd_buffer_size = 1M
bulk_insert_buffer_size = 1M
#myisam_sort_buffer_size = 1M
#myisam_max_sort_file_size = 10G
#myisam_max_extra_sort_file_size = 10G
#myisam_repair_threads = 1
#myisam_recover

lower_case_table_names = 1
skip-name-resolve
slave-skip-errors = 1032,1062
#replicate-ignore-db=mysql

server-id = 1

innodb_additional_mem_pool_size = 4M
innodb_buffer_pool_size = 32M
innodb_data_file_path = ibdata1:128M:autoextend
innodb_file_io_threads = 4
innodb_thread_concurrency = 8
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 4M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
innodb_file_per_table = 0

[mysqldump]
quick
max_allowed_packet = 2M

[mysqld_safe]
log-error=$i_db_base_dir/mysql_${i_install_port}.err
pid-file=$i_db_base_dir/mysqld.pid

EOF
# END 一键生成mysql配置文件 

###############################################################
# 一键生成mysql启停脚本 BEGIN
###############################################################
  echo "-->Step $i_step,`date +'%F_%T'`,一键生成mysql启停脚本 ${i_db_base_dir}/mysql ." | tee -a $i_install_log
  i_step=$(($i_step+1))
  cat > $i_db_base_dir/mysql <<EOF

#############################################################
# $i_db_base_dir/mysql 启停脚本 
#############################################################
CmdPath="/opt/mysql/bin"
mysql_user="$i_root"
mysql_pwd="$i_root_pwd"
port=$i_install_port
mysql_db_base=$i_db_base_dir
mysql_sock="\${mysql_db_base}/mysql.sock"

#startup function
function_start_mysql()
{
    if [ ! -e "\$mysql_sock" ];then
      printf "Starting MySQL...\n"
      /bin/sh \${CmdPath}/mysqld_safe --defaults-file=\${mysql_db_base}/my.cnf > /dev/null 2>&1 &
    else
      printf "MySQL is running...\n"
      exit
    fi
}

#stop function
function_stop_mysql()
{
    if [ ! -e "\$mysql_sock" ];then
       printf "MySQL is stopped...\n"
       exit
    else
       printf "Stoping MySQL...\n"
       \${CmdPath}/mysqladmin -u \${mysql_user} -p\${mysql_pwd} -S \${mysql_db_base}/mysql.sock shutdown
   fi
}

#restart function
function_restart_mysql()
{
    printf "Restarting MySQL...\n"
    function_stop_mysql
    sleep 2
    function_start_mysql
}

case \$1 in
start)
    function_start_mysql
;;
stop)
    function_stop_mysql
;;
restart)
    function_restart_mysql
;;
*)
    printf "Usage: \${mysql_db_base}/mysql {start|stop|restart}\n"
esac

EOF
# END 一键生成mysql启停脚本

  # 修改mysql数据目录属主
  chown -R mysql:mysql $i_db_base_dir
  chown -R mysql:mysql $i_db_data_dir

  # 修改mysql启停脚本执行权限
  chmod +x $i_db_base_dir/mysql 

  # 模块加载
  echo "/opt/mysql/include" >> /etc/ld.so.conf
  echo "/opt/mysql/lib"     >> /etc/ld.so.conf
  ldconfig

  # 初始化数据库 
  echo "-->Step $i_step,`date +'%F_%T'`,初始化数据库." | tee -a $i_install_log
  i_step=$(($i_step+1))
  echo "  【Command】:/opt/mysql/scripts/mysql_install_db --basedir=/opt/mysql --datadir=$i_db_data_dir --user=mysql" | tee -a $i_install_log 
  /opt/mysql/scripts/mysql_install_db --basedir=/opt/mysql --datadir=$i_db_data_dir --user=mysql >> $i_install_log
  
  #初次启动，root没有密码
  echo "-->Step $i_step,`date +'%F_%T'`,mysql starting..." | tee -a $i_install_log
  i_step=$(($i_step+1))
  echo "  【Command】:/opt/mysql/bin/mysqld_safe --defaults-file=$i_db_base_dir/my.cnf > /dev/null 2>&1 &" | tee -a $i_install_log 
  /opt/mysql/bin/mysqld_safe --defaults-file=$i_db_base_dir/my.cnf > /dev/null 2>&1 & 
 
  # 睡眠时间要足够长，等待mysql启动成功后初始化密码 
  echo "-->Step $i_step,`date +'%F_%T'`,sleep 60 seconds." | tee -a $i_install_log
  i_step=$(($i_step+1))
  sleep 60 

  # 设置root密码 
  echo "-->Step $i_step,`date +'%F_%T'`,设置root密码." | tee -a $i_install_log
  i_step=$(($i_step+1))
  echo "  【Command】:/opt/mysql/bin/mysqladmin -S $i_db_base_dir/mysql.sock -u${i_root} password \"${i_root_pwd}\" " >> $i_install_log
  /opt/mysql/bin/mysqladmin -S $i_db_base_dir/mysql.sock -u${i_root} password "${i_root_pwd}" 
  sleep 1
  
  # 登录测试
  echo "-->Step $i_step,`date +'%F_%T'`,一切OK了，登录测试一把." | tee -a $i_install_log
  i_step=$(($i_step+1))
  echo "  【Command】:/opt/mysql/bin/mysql -u${i_root} -p${i_root_pwd} -S $i_db_base_dir/mysql.sock -e \"show variables like '%character%'\" " | tee -a $i_install_log 
  /opt/mysql/bin/mysql -u${i_root} -p${i_root_pwd} -S $i_db_base_dir/mysql.sock -e "show variables like '%character%'" >> $i_install_log
  
else 
  echo "-->Step $i_step,`date +'%F_%T'`,mysql-5.5.32_bin_x86_64.tar.gz 不存在，请重新上传!!" | tee -a $i_install_log
  i_step=$(($i_step+1))
  exit 1
fi

