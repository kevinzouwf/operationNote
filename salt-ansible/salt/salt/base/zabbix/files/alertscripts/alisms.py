#!/usr/local/python-2.7.11/bin/python
# -*- coding: utf-8 -*-
import sys
import urllib2
import simplejson as json

class alisms:
    def __init__(Action,sigName,templateCode,recNum,ParamString)
        url = "https://sms.aliyuncs.com/?Action=SingleSendSms" \ 
              + "&SignName=阿里云短信服务" \
              + "&TemplateCode=SMS_1595010" \
              + "&RecNum=13011112222"    \
              + "&ParamString={"no":"123456"} \
              + &'
