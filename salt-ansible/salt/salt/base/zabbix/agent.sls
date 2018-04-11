include:
  - initial
  - salt.minion

zabbix-agent:
  pkg.installed:
    - name: zabbix-agent
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix/files/zabbix_agentd.conf
    - template: jinja
    - backup: minion
    - defaults:
        zabbix_server: {{ pillar['zabbix-agent']['Zabbix_Server'] }}
        Hostname: {{ grains.fqdn }}
    - require:
      - pkg: zabbix-agent
  service.running:
    - enable: True
    - watch:
      - pkg: zabbix-agent
      - file: zabbix-agent

zabbix-agent-role:
  file.append:
    - name: /etc/salt/roles
    - text:
      - 'zabbix-agent'
    - require:
      - file: roles
      - service: zabbix-agent
      - service: salt-minion
    - watch_in:
      - module: sync_grains
  
    
zabbix_agentd.conf.d:
  file.directory:
    - name: /etc/zabbix/zabbix_agentd.conf.d
    - watch_in:
      - service: zabbix-agent
    - require:
      - pkg: zabbix-agent
      - file: zabbix-agent

