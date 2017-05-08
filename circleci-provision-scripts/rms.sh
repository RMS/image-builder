#!/bin/bash
function install_rms() {
  (cat <<'EOF'
source ~/.circlerc
pyenv global 3.6.1
pip install lxml
pip install marathon
pip install dcos==0.4.14
pip install Jinja2==2.8
pip install msrestazure==0.4.1
pip install paramiko==2.0.1
pip install scp==0.10.2
pip install PyYAML==3.12
pip install azure==2.0.0rc5
pip install consul_kv
pip install keyring
pip install requests
sudo apt-get install jq
sudo wget https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_linux_amd64.zip
sudo wget https://releases.hashicorp.com/vault/0.6.4/vault_0.6.4_linux_amd64.zip
sudo unzip consul_0.7.3_linux_amd64.zip
sudo unzip vault_0.6.4_linux_amd64.zip
sudo mv consul /usr/local/bin/consul
sudo mv vault /usr/local/bin/vault
sudo apt-get -qqy update
sudo apt-get -qqy install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get -qqy update
sudo apt-get -qqy install ansible

EOF
  ) | as_user bash
}
