include:
  - packages
  - zabbix.agent
  - salt.minion
  - users.mysql

mysql_pkg:
  file.managed:
    - name: /usr/local/src/mysql-5.6.29.tar.gz
    - source: salt://mysql/files/mysql-5.6.29.tar.gz
    - mode: 644
decompress_mysql:
  cmd.run:
    - cwd: /usr/local/src/
    - name: tar zxf mysql-5.6.29.tar.gz
    - unless: test -d /usr/local/src/mysql-5.6.29

make_mysql:
  cmd.run:
    - cwd: /usr/local/src/mysql-5.6.29/
    - names:
      - mkdir -p /data/{3306,3307} && chown -R mysql.mysql /data/{3306,3307}
      - cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.29 -DMYSQL_DATADIR=/usr/local/mysql-5.6.29/data -DMYSQL_UNIX_ADDR=/usr/local/mysql-5.6.29/tmp/mysql.sock -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii -DENABLED_LOCAL_INFILE=ON -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITH_FAST_MUTEXES=1 -DWITH_ZLIB=bundled -DENABLED_LOCAL_INFILE=1 -DWITH_READLINE=1 -DWITH_EMBEDDED_SERVER=1 -DWITH_DEBUG=0 -DWITH_SSL=yes  && make && make install 
    - unless: test -d /usr/local/mysql-5.6.29


mysql_conf:
  file.recurse:
    - name: /data/3306/
    - source: salt://mysql/files/3306
    - template: jinja
    - user: mysql
    - group: mysql
    - idr_mode: 755
    - file_mode: 644
    - backup: minion
    - cmd.wait:
      - watch:
        - cmd: make_mysql
mysql-roles:
  file.append:
    - name: /etc/salt/roles
    - text:
      - 'mysql'
    - require:
      - file: roles
      - service: salt-minion
    - watch_in:
      - module: sync_grains
