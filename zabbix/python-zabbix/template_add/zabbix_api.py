#!/usr/bin/python
# -*- coding: UTF-8 -*-
import yaml
import xml.dom.minidom
import json
import os,sys
import urllib, urllib2
from urllib2 import Request, urlopen, URLError, HTTPError
zabbix_url="http://192.168.56.33/zabbix/api_jsonrpc.php"
zabbix_header={"Content-Type":"application/json"}
auth_code=""
zabbix_user=""
zabbix_pass=""

class zabbix_exception(Exception):
	pass
class zabbix_api(object):
	zabbix_user = ''
	zabbix_password = ''
	auth = ''
	def __init__(self):
		self.id=0
	def url_content(self,auth_data):
		request = urllib2.Request(zabbix_url,auth_data)
		for key in zabbix_header:
			request.add_header(key,zabbix_header[key])
		try:
			result = urllib2.urlopen(request)
		except HTTPError as e:
			raise zabbix_exception(e)
		else:
			response=json.loads(result.read())
			result.close()
		self.id += 1
		return response
	def json_data(self,method,params={},auth=True):
		obj = {
				"jsonrpc":"2.0",
				"method":method,
				"params": params,
				"auth": self.auth,
				"id":self.id
			}
		if not auth: del obj['auth']
		return json.dumps(obj)
	def login(self,user='',password='',save=True):
		if user != '':
			_zabbix_user = user
			_zabbix_pass = password
			if save:
				self.zabbix_user = user
				self.zabbix_pass = password
		elif self.zabbix_user != '':
			_zabbix_user = self.zabbix_user
			_zabbix_pass = self.zabbix_pass
		obj = self.json_data('user.login',{"user":_zabbix_user,"password":_zabbix_pass},auth=False)
		result=self.url_content(obj)
		self.auth=result['result']
#if __name__ == "__main__":
#
#	def main():
#		a=zabbix_api("Admin","zabbix")
#		#response= a.login()
#		#print response
#		a.import_tem()
#	main()
