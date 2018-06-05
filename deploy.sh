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
cat "${DIR}/2_initial_migration.js" | tee "${ORACLIZE}/migrations/2_initial_migration.js"
sed -i s/'${OAR}'/"${OAR}"/ "${ORACLIZE}/contracts/OraclizeTest.sol"
[[ -d "${ORACLIZE}/build" ]] || rm -rf "${ORACLIZE}/build"
truffle compile
truffle migrate --develop --reset
