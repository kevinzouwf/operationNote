jdk-install:
  file.managed:
    - name: /usr/local/src/jdk-7u79-linux-x64.tar.gz
    - source: salt://jdk/files/jdk-7u79-linux-x64.tar.gz
    - mode: 644
  cmd.run:
    - cwd: /usr/local/src/
    - names:
      - tar zxf jdk-7u79-linux-x64.tar.gz -C /usr/local/
    - unless: test -d /usr/local/jdk1.7.0_79
/usr/local/jdk:
  file.symlink:
    - target: /usr/local/jdk1.7.0_79
    - unless: test -d /usr/local/jdk
    - require:
      - cmd: jdk-install
java-profile
  file.managed:
    - name: /etc/profile.d/jdk.sh
    - source: salt://jdk/files/jdk.sh
    - mode: 644
