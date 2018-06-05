#!/bin/bash
#set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ORACLIZE="${DIR}/oraclize"
# ***************************************************************
# sudo apt-get -y install language-pack-zh-hans
export NVM_DIR="${HOME}/.nvm"
if ! nvm --version; then
    if [[ ! -d ${NVM_DIR} || ! -s "${NVM_DIR}/nvm.sh" || ! -s "${NVM_DIR}/bash_completion" ]]; then
        echo "# Installing nvm dependencies"
        sudo apt-get -y install build-essential libssl-dev
        echo "# Executing nvm installation script"
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    fi
fi
# Set up nvm environment without restarting the shell
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
# ***************************************************************
cd "${HOME}/quorum-examples/7nodes" && ./raft-init.sh && ./raft-start.sh
# ***************************************************************
function getOAR() {
    sleep 3
    OAR=`cat "${DIR}/ethereum-bridge.log" | grep 'OAR = OraclizeAddrResolverI(\S\{42\});' | awk -F \( '{print $2}' | awk -F \) '{print $1}'`
    if [[ ! ${OAR} ]]; then
        echo "waiting OAR"
        getOAR
    fi
}
[[ -d ${ORACLIZE} ]] || mkdir ${ORACLIZE}
cd ${ORACLIZE}
[[ "`ls -A`" != "" ]] || truffle init
[[ "`ls -A installed_contracts`" == "oraclize-api" ]] || truffle install oraclize-api
cat "${DIR}/config/2_initial_migration.js" | tee "${ORACLIZE}/migrations/2_initial_migration.js"
cat "${DIR}/config/truffle.js" | tee "${ORACLIZE}/truffle.js"
(
    getOAR
    echo "using ${OAR} and deploying OraclizeTest.sol"
    # https://github.com/WWWillems/medium-02-truffle-oraclize-api
    # tee "${ORACLIZE}/contracts/OraclizeTest.sol" <<EOF...${OAR=...}...EOF
    sed -i s/'${OAR}'/"${OAR}"/ OraclizeTest.sol
    cat "${DIR}/configOraclizeTest.sol" | tee "${ORACLIZE}/contracts/OraclizeTest.sol"
    [[ -d ./build ]] || rm -rf ./build
    truffle compile
    truffle migrate --develop --reset
    exit 0
) & (
    ethereum-bridge -a 0 -H 127.0.0.1 -p 22000 --gasprice 0 | tee "${DIR}/ethereum-bridge.log"
)