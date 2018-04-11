#!/usr/bin/python
# -*- coding: UTF-8 -*-

import json
import os,sys
import urllib, urllib2
from urllib2 import Request, urlopen, URLError, HTTPError
zabbix_url="http://192.168.56.11/zabbix/api_jsonrpc.php"
zabbix_header={"Content-Type":"application/json"}
auth_code=""

class zabbix_exception(Exception):
    pass
class zabbix_api(object):
    def __init__(self,zabbix_user,zabbix_pass):
        self.zabbix_user=zabbix_user
        self.zabbix_pass=zabbix_pass
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
        return response
    def gettoken(self):
        zabbix_user= self.zabbix_user
        zabbix_pass=self.zabbix_pass

        auth_data = json.dumps(
            {
                "jsonrpc":"2.0",
                "method":"user.login",
                "params":
                    {
                        "user":zabbix_user,
                        "password":zabbix_pass
                    },
                "id":0
            })
        a=self.url_content(auth_data)
        auth_code=a['result']
        return auth_code

if __name__ == "__main__":

    def main():
        a = zabbix_api("Admin","zabbix")
        response= a.gettoken()
        print response
    main()

