include:
  - users.www
  - nginx.install

server-nginx:
  service.running:
    - name: nginx
    - enable: True
