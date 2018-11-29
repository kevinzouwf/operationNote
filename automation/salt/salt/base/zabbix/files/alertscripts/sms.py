#!/usr/local/python-2.7.11/bin/python
# -*- coding: utf-8 -*-


import sys
from emaysms import EmaySMS, EmaySMSException
from weixin import weChat

reload(sys)
sys.setdefaultencoding( "utf-8" )

cdkey = '6SDK-EMY-6688-KGROO'
password = '200227'
emay = EmaySMS(cdkey, password)


Corpid = 'wx2e4d7c107edb3da0'  
Secret = 'BzAcwlBS0xnLvYLjDUprAmGMNZwtTzvlYNAoENVJTjQla4P80goc_zPHLE2Ick_t'  
url = 'https://qyapi.weixin.qq.com'
wechat = weChat(url,Corpid,Secret)
if __name__ == '__main__':
#    try:
#        mobile = sys.argv[1]
#    except IndexError:
#        mobile = '18010073860'
#    message=u"{0}".format(sys.argv[2])
#    emay.send(mobile, message)
    if emay.balance <= 200 :
        wechat.send_message(u'sandow',u"亿美钱不够啦")
    else:
        wechat.send_message(u'sandow',u"亿美余额还有{0}元".format(emay.balance))
