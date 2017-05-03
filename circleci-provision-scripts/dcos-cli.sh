
#!/bin/bash

function install_dcos_cli() {
    curl -fLsS --retry 20 -Y 100000 -y 60 https://downloads.dcos.io/binaries/cli/darwin/x86-64/dcos-1.8/dcos -o dcos && 
    sudo mv dcos /usr/local/bin && 
    sudo chmod +x /usr/local/bin/dcos && 
    dcos config set core.dcos_url http://10.92.1.40 && 
    dcos
}