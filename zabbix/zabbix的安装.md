# 环境准备
centos 6.x

 * selinux关闭
 * 防火墙关闭
 * 可访问外网
 * 安装gcc、vim

# zabbix服务端的安装

参考[zabbix官方安装文档](https://www.zabbix.com/documentation/2.4/manual/installation/install_from_packages)

## 环境准备

* 关闭防火墙
* 关闭selinux
* 做host解析

## 安装实战

1. 安装epel源（以备不需）

	```
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
	```
2. 安装mysql服务端

	```
	yum install mysql-server
	```	
3. 安装zabbix的官方源

	```
	rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
	```
4. 安装zabbix的master端

	```
	yum install zabbix-server-mysql zabbix-web-mysql
	```
5. 将mysql以及zabbix的master端加入开机自启动

	```
	chkconfig httpd on
	chkconfig mysqld on
	chkconfig zabbix-server on
	```
6. 将zabbix所必需的库导入到数据库

	```
	1. 启动mysql服务端
	   /etc/init.d/mysqld start
	
	2. 创建zabbix数据存放的数据库，并授权一个用户管理此库
	   mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
	   mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
	
	3. 将zabbix必需的数据文件导入到zabbix数据库
	   cd /usr/share/doc/zabbix-server-mysql-2.4.7/create/
	   mysql -uroot zabbix < schema.sql
	   mysql -uroot zabbix < images.sql
	   mysql -uroot zabbix < data.sql
	```
7. 编辑zabbix的master配置文件

	>\# vi /etc/zabbix/zabbix_server.conf

	```
	DBHost=localhost
	DBName=zabbix
	DBUser=zabbix
	DBPassword=zabbix
	```
	将相应项修改为上述
8. 启动zabbix服务

	```
	service zabbix-server start
	```
9. 编辑httpd配置文件，使zabbix服务可以顺利被appache服务代理

	>\# vi /etc/httpd/conf.d/zabbix.conf
	
	```
	php_value max_execution_time 300
	php_value memory_limit 128M
	php_value post_max_size 16M
	php_value upload_max_filesize 2M
	php_value max_input_time 300
	php_value date.timezone Asia/Shanghai
	```
	相应参数改为上述所示
	
10. 启动appache服务

	```
	/etc/init.d/httpd start
	```
	
11. 浏览器输入URL地址

	```
	http://10.0.0.106/zabbix
	```
	如果输入url回车后，出现zabbix的安装界面则表示zabbix服务端安装完成
	
# zabbix客户端的安装

1. 安装epel源（以备不需）

	```
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
	```
2. 安装zabbix的官方源

	```
	rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
	```
3. 安装zabbix的agent端

	```
	yum install zabbix-agent
	```
4. 将zabbix的客户端加入开机自启动

	```
	chkconfig zabbix-agent on
	```
5. 启动zabbix客户端

	```	
	/etc/init.d/zabbix-agent start
	```


# 源码完全安装

## 环境准备
centos 6.x

 * selinux关闭
 * 防火墙关闭
 * 可访问外网
 * 安装gcc、gcc-c++、vim

## 安装nginx

### 添加nginx用户

```
useradd -s /sbin/nologin -M www
```
### 安装nginx依赖

```
yum install -y pcre-devel openssl-devel 
```
### 安装nginx

1. 解压nginx源码包

	```
	mv ./nginx-1.9.14.tar.gz /usr/local/src/
	cd /usr/local/src/
	tar xf ./nginx-1.9.14.tar.gz 
	```
2. 编译nginx

	```
	cd nginx-1.9.14
	./configure \
	--prefix=/usr/local/nginx-1.9.14 \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--user=www \
	--group=www 
	```
3. 安装

	```
	make && make install && cd
	```
	
## 安装mysql

### 添加mysql用户

```
useradd -s /sbin/nologin -M mysql
```
### 安装mysql依赖

```
yum install -y cmake ncurses-devel libaio-devel
```

### 安装mysql

1. 解压mysql

	```
	mv ./mysql-5.5.32.tar.gz /usr/local/src/
	cd /usr/local/src/
	tar xf mysql-5.5.32.tar.gz 
	```
	
2. 编译mysql

	```
	cd mysql-5.5.32
	cmake \
	-DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.5.32 \
	-DMYSQL_DATADIR=/usr/local/mysql-5.5.32/data \
	-DMYSQL_UNIX_ADDR=/usr/local/mysql-5.5.32/tmp/mysql.sock \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci \
	-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \
	-DENABLED_LOCAL_INFILE=ON \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_FEDERATED_STORAGE_ENGINE=1 \
	-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
	-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
	-DWITHOUT_PARTITION_STORAGE_ENGINE=1 \
	-DWITH_FAST_MUTEXES=1 \
	-DWITH_ZLIB=bundled \
	-DENABLED_LOCAL_INFILE=1 \
	-DWITH_READLINE=1 \
	-DWITH_EMBEDDED_SERVER=1 \
	-DWITH_DEBUG=0
	```
	
3. 安装mysql

	```
	make && make install && cd 
	```
4. 初始化mysql数据库

	```
	/usr/local/mysql-5.5.32/scripts/mysql_install_db \
	--basedir=/usr/local/mysql-5.5.32 \
	--datadir=/usr/local/mysql-5.5.32/data  \
	--user=mysql \
	--group=mysql
	```

## 安装php

### 安装php的依赖

```
yum install -y gd-devel libjpeg-devel libpng-devel libxml2-devel bzip2-devel libcurl-devel
```
### 安装php

1. 解压php安装包

	```
	mv ./php-5.6.20.tar.gz /usr/local/src/
	cd /usr/local/src/
	tar xf php-5.6.20.tar.gz
	```
2. 编译php

	```
	./configure \
	--prefix=/home/caoyanan/php-5.5.32 \
	--with-config-file-path=/home/caoyanan/php-5.5.32/etc \
	--with-bz2 --with-curl --enable-ftp --enable-sockets \
	--disable-ipv6 --with-gd --with-jpeg-dir=/usr/local \
	--with-png-dir=/usr/local \
	-with-freetype-dir=/usr/local --enable-gd-native-ttf \
	--with-iconv-dir=/usr/local --enable-mbstring \
	--enable-calendar --with-gettext \
	--with-libxml-dir=/usr/local --with-zlib \
	--with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd \
	--with-mysql=mysqlnd --enable-dom --enable-xml \
	--enable-fpm --with-libdir=lib64 --enable-bcmath
	```
3. 安装php
## 安装zabbix客户端

### 安装zabbix客户端

1. 解压zabbix安装包

	```
	mv ./zabbix-2.4.7.tar.gz /usr/local/src/
	cd /usr/local/src/
	tar xf zabbix-2.4.7.tar.gz
	```
2. 编译zabbix客户端

	```
	cd zabbix-2.4.7
	./configure \
	--exec-prefix=/usr/local/zabbix-agent-2.4.7 \
	--enable-agent
	```
3. 安装zabbix客户端

	```
	make && make install && cd
	```
	
## 安装zabbix服务端

### 添加zabbix用户

```
useradd -s /sbin/nologin -M zabbix
```

### 安装zabbix服务端依赖

```
yum install -y net-snmp-devel libcurl-devel libxml2-devel mysql-devel
```

### 安装zabbix服务端

1. 解压zabbix包

	```
	mv ./zabbix-2.4.7.tar.gz /usr/local/src/
	cd /usr/local/src/
	tar xf zabbix-2.4.7.tar.gz
	```
2. 编译zabbix服务端

	```
	cd zabbix-2.4.7
	./configure \
	--prefix=/usr/local/zabbix-server-2.4.7 \
	--enable-server \
	--with-mysql 
	--with-net-snmp \
	--with-libcurl \
	--with-libxml2
	```
3. 安装zabbix服务端

	```
	make && make install && cd
	```	
	
### 部署zabbix的web界面
1. 拷贝zabbix-web的php代码

	```
	mkdir /usr/local/nginx-1.9.14/html/zabbix
	cp -r /usr/local/src/zabbix-2.4.7/frontends/php/* /usr/local/nginx-1.9.14/html/zabbix/
	```
2. 修改nginx的配置文件

	```
	```