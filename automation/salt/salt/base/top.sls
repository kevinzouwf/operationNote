base:
  'test.mikoshow.com':
    - nginx
    - mysql
    - php
  'showdb.mikoshow.com':
    - mysql
  'www.mikoshow.com':
    - nginx
    - php
#prod:
#  'linux-node*':
#    - cluster.haproxy-outside
