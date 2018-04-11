#!/usr/bin/env python
#coding: utf8

import yaml
import requests
import json
import os,sys
import time

def get_conf(project_name):
    conf_url = 'http://10.10.231.172/config/project-config.vhtml?projectName={0}&downloadEnvId=2'.format(project_name)
    r = requests.get(conf_url)
    configs = json.loads(r.content)

    nginx_file = []
    supervisord_file = []
    for item in configs['data']['configures']:
        if item['key'].startswith('nginx'):
            nginx_file.append(item['file_name'].encode('utf-8'))
        elif item['key'].startswith('supervisord'):
            supervisord_file.append(item['file_name'].encode('utf-8'))
        elif item['key'] == 'code_dir':
            code_dir = item['value'].encode('utf-8')
        if item['type'] == 2:
            config = item['value']
            f = open('{0}/{1}'.format(project_name,item['file_name']), 'w+')
            f.write(config.encode('utf-8'))
            f.close()

    #hosts_urls='http://10.10.11.120/cmdb/service/depDetail?project-name=fudao&service-name={0}&provider-nickname=ucloud'.format(project_name)
    hosts_urls='http://10.10.11.120/cmdb/service/depDetail?project-name=fudao&service-name=monitor&provider-nickname=ucloud'.format(project_name)
    host_data = json.loads(requests.get(hosts_urls).content)
    host_file=open('hosts','w+')
    for host in host_data['HostList']:
        host_file.write('{0}\n'.format(host['IP']))
    host_file.close()

    playbook_data =  [{'remote_user': 'wenba',
              'hosts': 'all', 
              'vars': 
                 {'project_name': project_name,
                  'tag': tag,
                  'code_dir': code_dir,
                  'nginx_file': nginx_file,
                  'supervisord_file': supervisord_file,
                }, 
               'roles': ['online']}
            ]
    fd = open("{0}.yml".format(project_name),'w+')
    yaml.dump(playbook_data,fd)
    fd.close

def tar_conf(project_name,tag):
   os.chdir('{0}'.format(project_name))
   os.system("composer install")
   os.system("composer update")
   file_name = "{0}-{1}.tar.gz".format(project_name,tag)
   if not os.path.exists(file_name):
      os.system("tar -zcf ../{0}-{1}.tar.gz ./ --exclude .git >/dev/null 2>&1".format(project_name,tag))


   
#def put_tar_package(project_name,tag):
#    file_name = "{0}-{1}.tar.gz".format(project_name,tag)
#    pravie_key_path = '/home/wenba/.ssh/id_rsa'
#    key = paramiko.RSAKey.from_private_key_file(pravie_key_path)
#    f = open('hosts','r')
#    for line in f.readlines():
#        print line
#    t = paramiko.Transport(('10.10.74.118',9922))
#    t.connect(username='wenba',pkey=key)
#
#    sftp = paramiko.SFTPClient.from_transport(t)
#    sftp.put(file_name,'/data/app/{0}'.format(file_name)) 
#
#    t.close() 

if __name__ == '__main__':
   if  len(sys.argv) != 3:
      print "Usage: %s project_name" %sys.argv[0]
   else:
      name = sys.argv[1]
      tag = sys.argv[2]
   get_conf(name)
   tar_conf(name,tag)
