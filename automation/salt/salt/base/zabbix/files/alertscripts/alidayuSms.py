#!/usr/local/python-2.7.11/bin/python
#       coding=utf-8
import sys
import urllib
import urllib2
def sendsms(phone,subject,host):
  url = "https://ca.aliyuncs.com/gw/alidayu/sendSms"    \
        + "?rec_num=%s" %phone   \
        + "&sms_template_code=SMS_12891203"     \
        + "&sms_free_sign_name=玩客"        \
        + "&sms_type=normal"    \
        + "&extend=1234"        \
        + '&sms_param={\"trigger\":\"%s\",\"status\":\"%s\",\"value\":\"%s\"}'%(subject,status,host)

  print(url)
  req=urllib2.Request(url)
  req.add_header("X-Ca-Key","23424776")
  req.add_header("X-Ca-Secret","3f1aaf2116f9f1b8dfbd133ac1779a73")
  resp=urllib2.urlopen(req)
  content=resp.read()
  if content:
    print(content)
if __name__ == '__main__':

    phone = sys.argv[1]
    text = sys.argv[2]
#    status = sys.argv[3]
#    message = sys.argv[4]
    status=text.split(':')[0]
    subject=text.split(':')[1].split('on')[0].strip().replace(' ','_') + "_is_" + text.split('is')[1].strip().split(' ')[0]
    host=text.split(':')[1].split('is')[0].split('on')[1].strip().split('.')[0]
   # print status >> /tmp/hello
   # print subject >> /tmp/hello
   # print host >> /tmp/hello
    sendsms(phone,subject,host)
