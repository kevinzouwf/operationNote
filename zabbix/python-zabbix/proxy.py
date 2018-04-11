#!/usr/bin/python
# -*- coding: UTF-8 -*-
from zabbix_api import zabbix_api
import yaml
import json

a = zabbix_api("Admin","zabbix")
response = a.login()

fp=open('proxy.yml','r')
data=yaml.load(fp)
data['auth']=response
print a.url_content(json.dumps(data))
#print data

#print response

