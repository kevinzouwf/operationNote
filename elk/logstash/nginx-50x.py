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
import redis
import urlparse 

def activity_urls():
    r = redis.Redis(host='10.10.34.151', port=6379, db=0,socket_connect_timeout=2)
    data=json.loads(r.hget('cms_keys','cms_60_page'))['data']
    urls=json.loads(data)
    return urls


activity_url = 'https://oapi.dingtalk.com/robot/send?access_token=c0e95d4bff5832431f8f72e7b0eb74d8880d43ffa984b10b3dfe24cb0f4605b9'
fudao_url = 'https://oapi.dingtalk.com/robot/send?access_token=355ab046de56997c7a42d644ecdb46600599d38af0eb5e8785c361174add86de'
def alert_data(url, host, data):
    send_data = {
     "msgtype": "markdown",
     "markdown": {
         "title": "fudao nginx not 200  报警",
         "text": "### fudao host: {0} \n\n#### messge: {1} \n\n".format(host, data),
                 }
      }
    r = requests.post(url, json=send_data)
    return r.content

if __name__ == "__main__" :
    host = sys.argv[1]
    request = urlparse.urlparse(sys.argv[2]).path
    message = sys.argv[3:]
    ctime=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
    log = open('/tmp/fudao_nginx500.log', 'a')
    try:
        urls = activity_urls()
        for item in urls:
            if request == urlparse.urlparse(item['url']).path:
                notify_url = activity_url
                notify_data = str(message) + item['charge'].encode('utf-8')
                break
            else:
                notify_url = fudao_url
                notify_data = str(message) 
        res = alert_data(notify_url, host, notify_data)
        log.writelines("time: {0} host: {1} message: {2} res: {3}\n".format(ctime,host, str(message),res))
    except Exception as e:
        log.writelines('error: {0}\n'.format(e))
    log.flush()
    log.close()
