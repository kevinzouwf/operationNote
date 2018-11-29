private_repo:
  file.managed:
    - name: /etc/yum.repos.d/privat.repo
    - source: salt://yum/files/privat.repo 
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - backup: minion
    - defaults:
      baseurl1: {{ pillar['private_yum']['baseurl1'] }}
      baseurl2: {{ pillar['private_yum']['baseurl2'] }}
