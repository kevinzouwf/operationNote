/etc/rsyslog.conf:
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://initial/files/rsyslog.conf
    - backup: minion
    - mode: 644
  service.running:
    - name: rsyslog
    - enable: True
    - reload: True
