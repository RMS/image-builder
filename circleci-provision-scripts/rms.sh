#!/bin/bash
function install_rms() {
  pyenv global 3.5.2
  pip3 install lxml
  pip3 install marathon
  pip3 install dcos==0.4.14
  pip3 install Jinja2==2.8
  pip3 install msrestazure==0.4.1
  pip3 install paramiko==2.0.1
  pip3 install scp==0.10.2
  pip3 install PyYAML==3.12
  pip3 install azure==2.0.0rc5
  pip3 install consul_kv
  pip3 install keyring
  pip3 install requests
}
