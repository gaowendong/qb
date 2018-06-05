#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# ***************************************************************
if ! nvm --version; then
    echo "# Installing nvm dependencies"
    sudo apt-get -y install build-essential libssl-dev
    echo "# Executing nvm installation script"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
fi
# Set up nvm environment without restarting the shell
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"
node -v || nvm install --lts
nvm ls-remote --lts | grep $(node -v) || nvm use --lts && nvm alias default 'lts/*'
node-gyp -v || sudo apt-fast install -y node-gyp
# ***************************************************************
truffle version || npm install -g truffle --registry=https://registry.npm.taobao.org
ethereum-bridge --version || npm install -g ethereum-bridge --registry=https://registry.npm.taobao.org
# ***************************************************************
npm run setup
npm run server
cd "${HOME}/quorum-examples/7nodes" && ./raft-init.sh && ./raft-start.sh
ethereum-bridge -a 0 -H 127.0.0.1 -p 22000 --gasprice 0 | tee "${DIR}/ethereum-bridge.log"
