amoeba-files:
  file.managed:
    - name: /usr/local/src/amoeba-mysql-3.0.5-RC.tar.gz
    - source: salt://amoeba/files/amoeba-mysql-3.0.5-RC.tar.gz
    - mode: 644
  cmd.run:
    - cwd: /usr/local/src/
    - names: 
      - tar zxf amoeba-mysql-3.0.5-RC.tar.gz -C /usr/local/
      - chown -R root.root /usr/local/amoeba-mysql-3.0.5-RC
    - unless:  test -d /usr/local/src/amoeba-mysql-3.0.5-RC.tar.gz
{% if not salt['file.directory_exists' ]('/usr/local/amoeba') %}
symlink:
  file.symlink:
    - target: /usr/local/amoeba-mysql-3.0.5-RC
    - name: /usr/local/amoeba
{% endif %}

#redis_conf:
#  file.managed:
#    - name: /usr/local/redis/conf/redis.conf
#    - source: salt://redis/files/redis.conf
#    - template: jinja
#    - defaultes:
#      bind: 127.0.0.1
#      port: 6379
#    - user: root
#    - group: root
#    - mode: 644
#    - backup: minion
#    - cmd.wait:
#      - watch:
#        - cmd: make_redis
#/etc/init.d/redis:
#  file.managed:
#    - source: salt://redis/files/redis
#    - mode: 755
#    - user: root
#    - group: root
#    - backup: minion
