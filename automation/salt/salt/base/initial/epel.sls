yum_repo_release:
  pkg.installed:
    - sources:
      - epel-release: http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm
    - unless: rpm -qa | grep epel-release-6
#test02_repo:
#  file.managed:
#    - name: /etc/yum.repos.d/test02.repo
#    - source: salt://initial/files/test02.repo
#    - backup: minion
#    - mode: 644
