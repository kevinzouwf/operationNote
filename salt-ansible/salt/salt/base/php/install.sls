{% set logdir = salt['pillar.get']('logdir', '/var/log/nginx') %}

include:
  - packages
  - php.libconv
  - zabbix.agent
  - salt.minion


/usr/local/src/php-5.5.30.tar.bz2:
  file.managed:
    - name: /usr/local/src/php-5.5.30.tar.bz2 
    - source: salt://php/files/php-5.5.30.tar.bz2
    - mode: 644
configue_php:
  cmd.run:
    - cwd: /usr/local/src/
    - name: tar xf php-5.5.30.tar.bz2
    - unless: test -d /usr/local/src/php-5.5.30
php_compile:
  cmd.run:
    - cwd: /usr/local/src/php-5.5.30/
    - names:
      - ./configure  --prefix=/usr/local/php-5.5.30 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir=/usr/local/libiconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-soap --enable-short-tags --enable-static --with-xsl --with-fpm-user=www --with-gettext --with-fpm-group=www --enable-ftp --enable-zip && make
      - make install
      - ln -s /usr/local/php-5.5.30 /usr/local/php
    - unless: test -d /usr/local/php-5.5.30
    - watch_in:
      - configue_php
/usr/local/php/etc/php-fpm.conf:
  file.managed:
    - source: salt://php/files/php-fpm.conf
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - backup: minion
/usr/local/php/lib/php.ini:
  file.managed:
    - source: salt://php/files/php.ini
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - backup: minion
/etc/init.d/php-fpm:
  file.managed:
    - source: salt://php/files/php-fpm
    - mode: 755
    - user: root
    - group: root
    - backup: minion
php-roles:
  file.append:
    - name: /etc/salt/roles
    - text:
      - 'php'
    - require:
      - file: roles
      - service: server-php
      - service: salt-minion
    - watch_in:
      - module: sync_grains
