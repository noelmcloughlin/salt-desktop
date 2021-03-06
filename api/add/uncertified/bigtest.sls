# For quick and dirty brute-force test of upstream/local states/pillars
base:
  '*':
    - apache
    - ceph.repo
    - chrony
    # linuxvda
    - deepsea
    #- devstack
    - docker
    - eclipse
    - etcd
    - etcd.docker
    - firewalld
    - golang
    - hadoop
    - iscsi
    - intellij
    - datagrip
    - phpstorm
    - webstorm
    - pycharm
    - goland
    - kerberos
    {%- if grains.os_family == 'Debian' %}
    - lxd
    {%- endif %}
    - lvm
    - maven
    - mysql
    - mongodb
    - java
    - packages
    - postgres
    - resolver
    # salt
    - samba
    - sqlplus
    - sqldeveloper
    - timezone
    - tomcat
    - users
    {%- if grains.os_family == 'RedHat' %}
    - epel
    {%- endif %}
