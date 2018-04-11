mysql_profile:
  file.append:
    - name: /etc/profile
    - text:
      - export PATH=/usr/local/mysql/bin:$PATH
