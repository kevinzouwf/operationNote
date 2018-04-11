#!/usr/bin/python
# -*- coding: UTF-8 -*-
from zabbix_api import zabbix_api
import yaml
import urllib
import json

a = zabbix_api()
a.login("Admin","zabbix")

fp=open('template_get.yml','r')
params=yaml.load(fp)
data = a.json_data('template.get',params,auth=True)
result =  a.url_content(data)
print result
templateId = result["result"][0]['templateid']
print templateId


#print a.url_content(urllib.urlencode(data))
#host_data = a.url_content(json.dumps(data))
#print json.dumps(host_data,sort_keys=True,indent=4)
#print response

