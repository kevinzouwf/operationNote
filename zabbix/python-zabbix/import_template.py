#!/usr/bin/python
# -*- coding: UTF-8 -*-
import yaml
import json
import os,sys
#import xml.dom.minidom
#dom = xml.dom.minidom.parse('zabbix_template_memcached.xml')
dom = open('zabbix_template_memcached.xml')
auth=login()
f = open('template.yml')
x = yaml.load(f)
x['auth'] = auth
x['params']['source'] = dom
print url_content(x)
