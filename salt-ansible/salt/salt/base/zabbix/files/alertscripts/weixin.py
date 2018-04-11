#!/usr/local/python-2.7.11/bin/python
# -*- coding: utf-8 -*-
import urllib2
import simplejson as json
import sys
class weChat:
    def __init__(self,url,Corpid,Secret): 
        url = '%s/cgi-bin/gettoken?corpid=%s&corpsecret=%s' % (url,Corpid,Secret)
        res = self.url_req(url)
        self.token = res['access_token']

    def url_req(self,url,method='get',data={}):
        if method == 'get':
            req = urllib2.Request(url)
            res = json.loads(urllib2.urlopen(req).read())
        elif method == 'post':
            req = urllib2.Request(url,data)
            res = json.loads(urllib2.urlopen(req).read())
        else:
            print 'error request method...exit'
            sys.exit()  
        return res
    def send_message(self,userlist,content,agentid=0):
        self.userlist = userlist
        self.content = content
        url = 'https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s' % self.token
        data = {
                      "touser": "",
                      "toparty": "",
                      "totag": "",
                      "msgtype": "text",
                      "agentid": "0",
                      "text": {
                          "content": ""
                      },
                      "safe":"0"
                   } 
        data['touser'] = userlist   
        data['agentid'] = agentid
        data['text']['content'] = content
        data = json.dumps(data,ensure_ascii=False)
    #   print data
        res = self.url_req(url,method='post',data=data)
        if res['errmsg'] == 'ok':
            result = 'send sucessed!!!' + '\t'
        else:
            result = 'send failed!!' + '\t'
            print res
        f = file('/tmp/python.log', 'a+')
        f.write(result)
        f.write(str(res) + '\n')
        f.close()



if __name__ == '__main__':  
      userlist = sys.argv[1]
      content = sys.argv[2:]
      content = '\n'.join(content)
      Corpid = 'wx2e4d7c107edb3da0'  #此处对应修改
      Secret = 'BzAcwlBS0xnLvYLjDUprAmGMNZwtTzvlYNAoENVJTjQla4P80goc_zPHLE2Ick_t'  #此处对应修改
      url = 'https://qyapi.weixin.qq.com'

      wechat = weChat(url,Corpid,Secret)
      wechat.send_message(userlist,content)
