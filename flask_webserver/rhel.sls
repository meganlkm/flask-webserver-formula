{% from "flask_webserver/map.jinja" import flask_webserver with context %}

install_prereqs:
  pkg.installed:
    - pkgs:
      - wget
    - refresh: True
    - require_in:
      - install_epel_repo

install_epel_repo:
  cmd.run:
    - name: wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && rpm -i --force epel-release-6-8.noarch.rpm
    - require_in:
      - install_state_packages

# the onlyif command will exit 0 if the repo is not installed
install_ius_release:
  cmd.run:
    - name: yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    - onlyif: "exit `yum repoinfo ius | grep '^repolist:' | awk '{ print $2 }'`"
    - require_in:
      - install_state_packages

install_state_packages:
  pkg.installed:
    - pkgs: "{{ flask_webserver.packages }}"
    - refresh: True
