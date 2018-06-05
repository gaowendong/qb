#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ORACLIZE="${DIR}/oraclize"
# OAR=0x6f485c8bf6fc43ea212e93bbf8ce046c7f1cb475
OAR=${1}
if [[ ! ${OAR} ]]; then
    echo "no OAR error"
    exit 0
fi
[[ -d ${ORACLIZE} ]] || mkdir ${ORACLIZE}
cd ${ORACLIZE}
[[ "`ls -A`" != "" ]] || truffle init
[[ "`ls -A installed_contracts`" == "oraclize-api" ]] || truffle install oraclize-api
cat "${DIR}/config/truffle.js"             | tee "${ORACLIZE}/truffle.js"
cat "${DIR}/config/OraclizeTest.sol"       | tee "${ORACLIZE}/contracts/OraclizeTest.sol"
cat "${DIR}/config/2_initial_migration.js" | tee "${ORACLIZE}/migrations/2_initial_migration.js"
sed -i s/'${OAR}'/"${OAR}"/ "${ORACLIZE}/contracts/OraclizeTest.sol"
[[ -d "${ORACLIZE}/build" ]] || rm -rf "${ORACLIZE}/build"
truffle compile
truffle migrate --develop --reset
