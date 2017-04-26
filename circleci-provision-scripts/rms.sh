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
EOF
  ) | as_user bash
}
