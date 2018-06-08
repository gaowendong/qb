#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ORACLIZE="${DIR}/oraclize"
BLK="${DIR}/blk-explorer-free"
NODE_HOST=localhost
# ***************************************************************
export NVM_DIR="${HOME}/.nvm"
if ! nvm --version; then
    if [[ ! -d ${NVM_DIR} || ! -s "${NVM_DIR}/nvm.sh" || ! -s "${NVM_DIR}/bash_completion" ]]; then
        echo "# Installing nvm dependencies"
        sudo apt -y install build-essential libssl-dev
        echo "# Executing nvm installation script"
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    fi
fi
# Set up nvm environment without restarting the shell
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"

sudo apt -y install language-pack-zh-hans
node -v || nvm install --lts
nvm ls-remote --lts | grep $(node -v) || nvm use --lts && nvm alias default 'lts/*'
sudo apt update
node-gyp -v || sudo apt install -y node-gyp
truffle version || npm install -g truffle --registry=https://registry.npm.taobao.org
ethereum-bridge --version || npm install -g ethereum-bridge --registry=https://registry.npm.taobao.org
# ***************************************************************
if ! docker -v; then
    sudo apt -y install docker.io
fi
sudo usermod -aG docker $(whoami)
[[ -d /etc/docker ]] || sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://bsy887ib.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

set +e
COUNT="$(python -V 2>&1 | grep -c 2.)"
if [ ${COUNT} -ne 1 ]
then
   sudo apt install -y python-minimal
fi
set -e
sudo apt install -y python-pip
docker-compose --version || sudo pip install docker-compose
# ***************************************************************
if [[ ${1} ]]; then
    NODE_HOST=${1}
    echo "error:not support"
else
    "${DIR}/7nodes.sh"
fi
cd ${DIR}
grep '127.0.0.1\s\+api.test.com' /etc/hosts || echo '127.0.0.1  api.test.com' | sudo tee -a /etc/hosts
npm run setup
npm run server
[[ -d ${BLK} && $(ls -A ${BLK}) != "" ]] || git clone https://github.com/blk-io/blk-explorer-free.git ${BLK}
NODE_ENDPOINT="http://${NODE_HOST}:22000" docker-compose -f "${BLK}/linux-docker-compose.yaml" down
NODE_ENDPOINT="http://${NODE_HOST}:22000" docker-compose -f "${BLK}/linux-docker-compose.yaml" up -d
