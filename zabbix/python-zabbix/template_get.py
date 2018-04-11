#!/usr/bin/python
# -*- coding: UTF-8 -*-
from zabbix_api import zabbix_api
import yaml
import urllib
import json

a = zabbix_api()
response = a.login("Admin","zabbix")

fp=open('template_get.yml','r')
data=yaml.load(fp)
data['auth']=response


#print a.url_content(urllib.urlencode(data))
host_data = a.url_content(json.dumps(data))
print json.dumps(host_data,sort_keys=True,indent=4)
#print response

