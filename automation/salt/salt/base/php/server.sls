include:
  - users.www
  - php.install
server-php:
  service.running:
    - name: php-fpm
    - enable: True
