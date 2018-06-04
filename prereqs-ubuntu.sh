#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -d "${HOME}/qb" ]] || mkdir "${HOME}/qb"
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
npm install --registry=https://registry.npm.taobao.org -g truffle
npm install --registry=https://registry.npm.taobao.org -g ethereum-bridge
# ***************************************************************
[[ -d "${DIR}/oraclize" ]] || (
    mkdir "${DIR}/oraclize" && cd "${DIR}/oraclize"
    truffle init
    truffle install oraclize-api
)
# https://github.com/WWWillems/medium-02-truffle-oraclize-api
cat "${DIR}/config/OraclizeTest.sol" | tee "${DIR}/oraclize/contracts/OraclizeTest.sol"
rm -rf ./build/; truffle compile
cat "${DIR}/config/2_initial_migration.js" | tee "${DIR}/oraclize/migrations/2_initial_migration.js"
cat "${DIR}/config/truffle.js" | tee "${DIR}/oraclize/truffle.js"
#tee "${DIR}/oraclize/truffle.js" <<-'EOF'
# ***************************************************************
cd "${HOME}/quorum-examples/7nodes" && ./raft-init.sh && ./raft-start.sh
ethereum-bridge -a 0 -H 127.0.0.1 -p 22000 --gasprice 0 | tee ethereum-bridge.log
