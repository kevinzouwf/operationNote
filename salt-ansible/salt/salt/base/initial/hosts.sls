/etc/hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://initial/files/hosts
    - backup: minion
    - mode: 644
