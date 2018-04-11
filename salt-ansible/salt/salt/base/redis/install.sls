{% set redis_dbdir = salt['pillar.get']('redis:dir', '/data/redis/') %}
{% set redis_logdir = salt['pillar.get']('redis_logdir', '/var/log/redis') %}
redis_pkg:
  file.managed:
    - name: /usr/local/src/redis-3.2.5.tar.gz
    - source: salt://redis/files/redis-3.2.5.tar.gz
    - mode: 644
decompress_redis:
  cmd.run:
    - cwd: /usr/local/src/
    - name: tar zxf redis-3.2.5.tar.gz
    - unless: test -d /usr/local/src/redis-3.2.5
make_redis:
  cmd.run:
    - cwd: /usr/local/src/redis-3.2.5/
    - names:
      - make  MALLOC=jemalloc && make PREFIX=/usr/local/redis-3.2.5 install && ln -s /usr/local/redis-3.2.5 /usr/local/redis && mkdir /usr/local/redis-3.2.5/conf/ -p && cp /usr/local/src/redis-3.2.5/src/redis-trib.rb /usr/local/redis/bin
    - unless: test -d /usr/local/redis-3.2.5
{{ redis_dbdir }}:
  cmd.run:
    - name: mkdir -p {{ redis_dbdir }}
    - unless: test -d {{ redis_dbdir }}
{{ redis_logdir }}:
  cmd.run:
    - name: mkdir -p {{ redis_logdir }}
    - unless: test -d {{ redis_logdir }}
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
