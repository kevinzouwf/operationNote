mysql:
  group.present:
    - gid: 889
  user.present:
    - uid: 889
    - gid: 889
    - shell: /sbin/nologin
    - createhome: False
