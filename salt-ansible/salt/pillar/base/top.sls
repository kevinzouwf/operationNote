base:
  '*':
    - zabbix.agent
#    - roles.common
#    - users
  'passport*.wankr.com.cn':
    - roles.web
  'ytadmin*.wankr.com.cn':
    - roles.www
  'www.wankr.com.cn':
    - roles.www
  'test02.wankr.com.cn':
    - roles.admin
  'testweb*':
    - roles.web
  '*.www.gsandow.com':
    - roles.private_yum
  'host1.www.gsandow.com':
    - roles.amoeba
