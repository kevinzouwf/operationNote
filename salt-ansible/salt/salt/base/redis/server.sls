include:
  - redis.install
  - initial.sysctl

{% for redis_roles, args in pillar['redis-server1'].iteritems() %}
{{ redis_roles }}:
  file.managed:
    - source: salt://redis/files/test
    - name: /usr/local/redis/conf/{{args['port']}}.conf
    - template: jinja
    - defaultes:
      redis_role: {{ redis_roles }}
      master: {{ args['master'] }}
      master_port: {{ args['master_port'] }}
{% endfor%}
#{% for redis_roles, args in pillar['redis-server1'].iteritems() %}
#/etc/init.d/{{ redis_roles }}:
#  file.managed:
#    - source: salt://redis/files/redis
#    - template: jinja
#    - mode: 755
#    - defaultes:
#      redis_role: {{ redis_roles }}
#  service.running:
#    - name: {{ redis_roles }}
#    - enable: True
#    - watch:
#      - file: {{redis_roles}}
#{% endfor%}
