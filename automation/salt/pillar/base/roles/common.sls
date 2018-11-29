include:
  - users
  - salt.minion
  - zabbix.agent
limit_users:
  www:
    limit_hard: 65535
    limit_soft: 65535
    limit_type: nofile
