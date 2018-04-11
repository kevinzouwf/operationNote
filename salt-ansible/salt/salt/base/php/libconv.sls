/usr/local/src/libiconv-1.14.tar.gz:
  file.managed:
    - name: /usr/local/src/libiconv-1.14.tar.gz
    - source: salt://php/files/libiconv-1.14.tar.gz
    - mode: 644
configue_libiconv:
  cmd.run:
    - cwd: /usr/local/src/
    - name: tar xf libiconv-1.14.tar.gz
    - unless: test -d /usr/local/src/libiconv-1.14
libiconv_compile:
  cmd.run:
    - cwd: /usr/local/src/libiconv-1.14
    - names:
      - ./configure  --prefix=/usr/local/libiconv && make
      - make install
    - unless: test -d /usr/local/libiconv
    - watch_in:
      - configue_libiconv
