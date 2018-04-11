include:
#  - users.www
  - tomcat.install

server-tomcat:
  service.running:
    - name: tomcat
    - enable: True
