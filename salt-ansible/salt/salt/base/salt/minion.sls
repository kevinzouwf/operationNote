salt-minion:
  pkg.installed:
    - name: salt-minion
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/files/minion
    - template: jinja
    - defaults:
      master: ns1.www.gsandow.com
    - require:
      - pkg: salt-minion
  service.running:
    - enable: True
    - watch:
      - pkg: salt-minion
      - file: salt-minion
roles:
  file.managed:
    - name: /etc/salt/roles
sync_grains:
  module.wait:
    - name: saltutil.sync_grains

mine_update:
  module.run:
    - name: mine.update
    - require:
      - module: sync_grains

salt-minion-grains:
  file.managed:
    - name: /etc/salt/grains
    - order: 1
    - source: salt://salt/files/grains
    - template: jinja
    - defaults:
        hostgroup: {{salt['pillar.get']('hostgroup', 'Salt-Discovery')}}
    - require:
      - pkg: salt-minion
    - watch_in:
      - module: sync_grains
salt-minion-role:
  file.append:
    - name: /etc/salt/roles
    - text:
      - 'salt-minion'
    - require:
      - file: roles
      - service: salt-minion
    - watch_in:
      - module: sync_grains
