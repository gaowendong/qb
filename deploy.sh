#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ***************************************************************
[[ -d "${DIR}/oraclize" ]] || (
    mkdir "${DIR}/oraclize"
    cd "${DIR}/oraclize"
    truffle init
    truffle install oraclize-api
)
if [[ ${1} ]]; then
    OAR=${1}
fi
# https://github.com/WWWillems/medium-02-truffle-oraclize-api
tee "${DIR}/oraclize/contracts/OraclizeTest.sol" <<EOF
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
cd "${DIR}/oraclize"
[[ -d ./build ]] || rm -rf ./build
truffle compile
cat "${DIR}/config/2_initial_migration.js" | tee "${DIR}/oraclize/migrations/2_initial_migration.js"
cat "${DIR}/config/truffle.js" | tee "${DIR}/oraclize/truffle.js"
truffle migrate --develop --reset