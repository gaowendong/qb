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
[[ "`ls -A`" == "" ]] || truffle init
[[ "`ls -A installed_contracts`" == "" ]] || truffle install oraclize-api
cat "${DIR}/config/2_initial_migration.js" | tee "${ORACLIZE}/migrations/2_initial_migration.js"
cat "${DIR}/config/truffle.js" | tee "${ORACLIZE}/truffle.js"
(
    getOAR
    echo "using ${OAR} and deploying OraclizeTest.sol"
    # https://github.com/WWWillems/medium-02-truffle-oraclize-api
    tee "${ORACLIZE}/contracts/OraclizeTest.sol" <<EOF
pragma solidity ^0.4.21;
import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";

contract OraclizeTest is usingOraclize {

    address owner;
    string public ETHUSD;

    event LogInfo(string description);
    event LogPriceUpdate(string price);
    event LogUpdate(address indexed _owner, uint indexed _balance);

    // Constructor
    function OraclizeTest()
    payable
    public {
        owner = msg.sender;

        emit LogUpdate(owner, address(this).balance);

        // Replace the next line with your version:
        OAR = OraclizeAddrResolverI(${OAR=0x98d52C3C3959B35496477510920e2C99E6e9cAC0});

        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        update();
    }

    // Fallback function
    function()
    public{
        revert();
    }

    function __callback(bytes32 myid, string result, bytes proof)
    public {
        require(msg.sender == oraclize_cbAddress());

        ETHUSD = result;
        emit LogPriceUpdate(ETHUSD);
        update();
    }

    function getBalance()
    public
    returns (uint _balance) {
        return address(this).balance;
    }

    function update()
    payable
    public {
        // Check if we have enough remaining funds
        if (oraclize_getPrice("URL") > address(this).balance) {
            emit LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit LogInfo("Oraclize query was sent, standing by for the answer..");

            // Using XPath to to fetch the right element in the JSON response
            oraclize_query("URL", "json(https://api.coinbase.com/v2/prices/ETH-USD/spot).data.amount");
        }
    }

}
EOF
    [[ -d ./build ]] || rm -rf ./build
    truffle compile
    truffle migrate --develop --reset
    exit 0
) & (
    ethereum-bridge -a 0 -H 127.0.0.1 -p 22000 --gasprice 0 | tee "${DIR}/ethereum-bridge.log"
)