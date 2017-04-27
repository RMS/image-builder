#!/bin/bash
function install_rms() {
  (cat <<'EOF'
source ~/.circlerc
pyenv global 3.5.2
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
apt-get install jq
apt-get install sshuttle
echo "\n" | ssh-add /home/ubuntu/.ssh/id_*
wget https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_linux_amd64.zip
wget https://releases.hashicorp.com/vault/0.6.4/vault_0.6.4_linux_amd64.zip
unzip consul_0.7.3_linux_amd64.zip
unzip vault_0.6.4_linux_amd64.zip
sudo mv consul /usr/local/bin/consul
sudo mv vault /usr/local/bin/vault
consul agent -dev &
sleep 20s
vault server -dev -dev-root-token-id="test-token" &
sleep 10s
consul kv put system/domain azure.rmsonecloud.net
consul kv put system/environment test
vault write secret/postgres/user value=postgres
vault write secret/postgres/password value=password
vault write secret/2/postgres/user value=postgres2
vault policy-write rms-policy rms.hcl
curl -X POST -H "X-Vault-Token:test-token" -d '{"type":"approle"}' http://127.0.0.1:8200/v1/sys/auth/approle
curl -X POST -H "X-Vault-Token:test-token" -d '{"policies":"rms-policy"}' http://127.0.0.1:8200/v1/auth/approle/role/rms
echo "export VAULT_SECRET_ID=$(curl --silent -X POST -H "X-Vault-Token:test-token" http://127.0.0.1:8200/v1/auth/approle/role/rms/secret-id | jq -r .data.secret_id)" >> ~/.circlerc
echo "export VAULT_ROLE_ID=$(curl --silent -X GET -H "X-Vault-Token:test-token" http://127.0.0.1:8200/v1/auth/approle/role/rms/role-id | jq -r .data.role_id)" >> ~/.circlerc
EOF
  ) | as_user bash
}
