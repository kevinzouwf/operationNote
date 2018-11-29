include:
  - initial
  - salt.minion
  - nginx

create_repo:
  pkg.installed:
    - name: createrepo
  file.directory:
    - names:
      - /yum/redhat/base/6/x86_64
      - /yum/redhat/base/7/x86_64
    - makedirs: True
    - user: www
    - group: www
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
config_nginx:
  file.managed:
    - name: /usr/local/nginx/conf/vhost/yumrepo.conf
    - source: salt://yum/files/yumrepo.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - backup: minion
    - defaults:
      baseurl1: {{ pillar['private_yum']['baseurl1'] }}
      baseurl2: {{ pillar['private_yum']['baseurl2'] }}
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: config_nginx
#   - require:
#      - file: /usr/local/nginx
