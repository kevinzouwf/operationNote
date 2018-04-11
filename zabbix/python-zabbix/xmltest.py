#!/usr/bin/python
# -*- coding: UTF-8 -*-
#import xml.dom.minidom
#dom = xml.dom.minidom.parse('zabbix_template_memcached.xml')
#print dom.toprettyxml()
tree = open('zabbix_template_memcached.xml')
print tree.read()
tree.close()
