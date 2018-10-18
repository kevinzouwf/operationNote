#!/usr/bin/env python
# coding=utf-8
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
from pyzabbix import ZabbixAPI
from datetime import datetime
import time
# The hostname at which the Zabbix web interface is available
ZABBIX_SERVER = 'http://10.5.42.11/zabbix'
ZABBIX_new = 'http://10.16.33.30'
zapi = ZabbixAPI(ZABBIX_SERVER)
zapi_new = ZabbixAPI(ZABBIX_new)
# Login to the Zabbix API
zapi.login("Admin", "zabbix")
zapi_new.login("Admin", "zabbix")
 
def get_hosts():
    hosts =zapi.host.get(output=['name',],groupids=10)
    for host in hosts:
        host_name=host['name']
        host_ip=host_name.split('-')[0]
        #group_id = groups_id = zapi.hostgroup.get({"output": "groupid","filter": {"name":'Template SNMP Device'}})
        proxy_id = zapi_new.proxy.get({"output": "proxyid","selectInterface": "extend","filter":{"host":'yw-zabbix-proxy-01'}})[0]['proxyid']
        zapi_new.host.create({"host":host_ip,
                          "groups":[{'groupid':'27'}],
                          "templates":[{'templateid':'10066'}],
                          "interfaces":[{"type":2,"main":1,
                                         "useip":1,"ip":host_ip,
                                         "dns":"","port":"161"}],
                          "proxy_hostid":proxy_id})
 
get_hosts()
