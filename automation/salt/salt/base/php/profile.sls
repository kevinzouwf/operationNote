php_profile:
  file.append:
    - name: /etc/profile
    - text:
      - export PATH=/usr/local/php/bin:$PATH
