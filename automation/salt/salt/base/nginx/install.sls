
{% set logdir = salt['pillar.get']('logdir', '/var/log/nginx') %}

include:
  - users.www
  - packages
  - zabbix.agent
  - salt.minion


nginx-pkg:
  file.managed:
    - name: /usr/local/src/nginx-1.9.14.tar.gz
    - source: salt://nginx/files/nginx-1.9.14.tar.gz
    - mode: 644
uncompress_nginx:
  cmd.run:
    - cwd: /usr/local/src/
    - name: tar zxf nginx-1.9.14.tar.gz
    - unless: test -d /usr/local/src/nginx-1.9.14
make_nginx:
  cmd.run:
    - cwd: /usr/local/src/nginx-1.9.14/
    - names:
      - ./configure --prefix=/usr/local/nginx-1.9.14 --user=www --group=www --with-file-aio --with-http_dav_module --with-pcre --with-http_stub_status_module --with-http_xslt_module --with-http_ssl_module --with-http_realip_module && make && make install && ln -s /usr/local/nginx-1.9.14 /usr/local/nginx
    - unless: test -d /usr/local/nginx-1.9.14

nginx_vhost:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - makedirs: True
    - cmd.wait:
      - watch:
        - cmd: make_nginx
/usr/local/nginx/conf/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - backup: minion
/etc/init.d/nginx:
  file.managed:
    - source: salt://nginx/files/nginx
    - mode: 755
    - user: root
    - group: root
    - backup: minion
{{ logdir }}:
  cmd.run:
    - name: mkdir -p {{ logdir }}
    - unless: test -d {{ logdir }}

server-nginx:
  service.running:
    - name: nginx
    - enable: True
    - reload: True

nginx-roles:
  file.append:
    - name: /etc/salt/roles
    - text:
      - 'nginx'
    - require:
      - file: roles
      - service: server-nginx
      - service: salt-minion
    - watch_in:
      - module: sync_grains

