#!/usr/bin/env python
# coding=utf-8
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
import sys,time
import requests
import json
import urlparse

def alert_data(url, subject, data):
    headers = {'Content-Type': 'application/json;charset=utf-8'}
    send_data = {
     "msgtype": "markdown",
     "markdown": {
         "title": "zabbix 报警",
         "text": "###  subject: {0} \n\n#### messge: {1} \n\n".format(subject, data),
                 }
      }
    r = requests.post(url, headers=headers, json=send_data)
    return r.content

if __name__ == "__main__" :
    dingding_url = "https://oapi.dingtalk.com/robot/send?access_token={}".format(sys.argv[1])
    subject = str(sys.argv[2]).replace('\r\n','\n\n')
    message = str(sys.argv[3]).replace('\r\n','\n\n')
    ctime=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
    log = open('/tmp/zabbix_alter.log', 'a')
    try:
        notify_url = dingding_url
        notify_data = str(message)
        res = alert_data(notify_url, subject, notify_data)
        log.writelines("time: {0} host: {1} message: {2} res: {3},,,{4}\n".format(ctime,subject, str(message),res, dingding_url))
    except Exception as e:
        log.writelines('error: {0}\n'.format(e))
    log.flush()
    log.close()

