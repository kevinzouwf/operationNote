#!/usr/bin/python
# -*- coding: UTF-8 -*-
from zabbix_api import zabbix_api
import yaml
import urllib
import json

a = zabbix_api()
a.login("Admin","zabbix")

def get_hostid():
	obj = {
		"output": ["hostid"],
		"selectParentTemplates": ["templateid", "name"],
		"filter": {
			"host":["zabbix_agent"]
		},
		}
	host_data = a.json_data('host.get',obj)
	result = a.url_content(host_data)
	hostinterface_data = a.json_data('hostinterface.get',{"output":"extend","hostids":"10125"})
	hostinterface_id = a.url_content(hostinterface_data)
	print hostinterface_id
	print result
	return result,hostinterface_id
def get_templateid():
	obj = {
		"output":["templateid","host"],
		"filter": {"host":["Templates nginx stauts"]}
	}
	template_data = a.json_data('template.get',obj)
	result = a.url_content(template_data)
	print result
	return result
def add_item():
	keys = {
		"nginx_active":"linux_status[nginx_status,80,active]",
		"nginx_reading":"linux_status[nginx_status,80,reading]",
		"nginx writing": "linux_status[nginx_status,80,writing]",
		"nginx waiting": "linux_status[nginx_status,80,waiting]",
		"nginx handled connections": "linux_status[nginx_status,80,handled]",
		"nginx accepts connections": "linux_status[nginx_status,80,accepts]",
		"nginx requests connections": "linux_status[nginx_status,80,requests]"
	}
	result = get_templateid()
	templateId =  result["result"][0]["templateid"]
	for k,v in keys.items():
		nginx_items = {"hostid":"10125","interfaceid":21,"templateid":templateId,"type":0,"value_type":3,"delay":30}
		nginx_items["name"] = k
		nginx_items["key_"] = v
		item_date = a.json_data('item.create',nginx_items,auth=True)
		print item_date
		item_result = a.url_content(item_date)
		print "--------", item_result

#print a.url_content(urllib.urlencode(data))
#host_data = a.url_content(json.dumps(data))
#print json.dumps(host_data,sort_keys=True,indent=4)
#print response

if __name__ == "__main__":
	def main():
		#get_hostid()
		get_templateid()
		add_item()
	main()
