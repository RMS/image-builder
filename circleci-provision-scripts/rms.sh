#!/bin/bash
function install_rms() {
  (cat <<'EOF'
source ~/.circlerc
sudo pyenv global 3.6.1
sudo pip install lxml
sudo pip install marathon
sudo pip install dcos==0.4.14
sudo pip install Jinja2==2.8
sudo pip install msrestazure==0.4.1
sudo pip install paramiko==2.0.1
sudo pip install scp==0.10.2
sudo pip install PyYAML==3.12
sudo pip install azure==2.0.0rc5
sudo pip install consul_kv
sudo pip install keyring
sudo pip install requests
sudo apt-get install jq
sudo wget https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_linux_amd64.zip
sudo wget https://releases.hashicorp.com/vault/0.6.4/vault_0.6.4_linux_amd64.zip
sudo unzip consul_0.7.3_linux_amd64.zip
sudo unzip vault_0.6.4_linux_amd64.zip
sudo mv consul /usr/local/bin/consul
sudo mv vault /usr/local/bin/vault
sudo consul agent -dev &
sleep 20s
sudo vault server -dev -dev-root-token-id="test-token" &
sleep 10s
consul kv put system/domain azure.rmsonecloud.net
consul kv put system/environment test
export VAULT_ADDR=http://127.0.1:8200/
sudo -E vault write secret/postgres/user value=postgres
sudo -E vault write secret/postgres/password value=password
sudo -E vault write secret/2/postgres/user value=postgres2
sudo -E vault policy-write rms-policy rms.hcl
curl -X POST -H "X-Vault-Token:test-token" -d '{"type":"approle"}' http://127.0.0.1:8200/v1/sys/auth/approle
curl -X POST -H "X-Vault-Token:test-token" -d '{"policies":"rms-policy"}' http://127.0.0.1:8200/v1/auth/approle/role/rms
sudo echo "export VAULT_SECRET_ID=$(export VAULT_ADDR=http://127.0.1:8200/ && curl --silent -X POST -H "X-Vault-Token:test-token" http://127.0.0.1:8200/v1/auth/approle/role/rms/secret-id | jq -r .data.secret_id)" >> ~/.circlerc
sudo echo "export VAULT_ROLE_ID=$(export VAULT_ADDR=http://127.0.1:8200/ && curl --silent -X GET -H "X-Vault-Token:test-token" http://127.0.0.1:8200/v1/auth/approle/role/rms/role-id | jq -r .data.role_id)" >> ~/.circlerc
sudo apt-get -qqy update
sudo apt-get -qqy install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get -qqy update
sudo apt-get -qqy install ansible
EOF
  ) | as_user bash
}
