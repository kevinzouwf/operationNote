tomcat_path:
  file.append:
    - name: /etc/profile.d/tomcat.sh
    - text:
      - export TOMCAT_HOME=/usr/local/tomcat
