#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ORACLIZE="${DIR}/oraclize"
# ***************************************************************
[[ -d ${ORACLIZE} ]] || mkdir ${ORACLIZE}
cd ${ORACLIZE}
[[ "`ls -A`" != "" ]] || truffle init
[[ "`ls -A installed_contracts`" == "oraclize-api" ]] || truffle install oraclize-api
rm -rf "${ORACLIZE}/contracts/" "${ORACLIZE}/migrations/"
cp ${DIR}/config/*.sol                  "${ORACLIZE}/contracts/"
cp ${DIR}/config/*_initial_migration.js "${ORACLIZE}/migrations/"
cp "${DIR}/config/truffle.js"           "${ORACLIZE}/truffle.js"
# ***************************************************************
OAR=${1}
if [[ ! ${OAR} ]]; then
    echo "no OAR error"
    exit 0
fi
sed -i s/'${OAR}'/"${OAR}"/ "${ORACLIZE}/contracts/OraclizeTest.sol"
[[ -d "${ORACLIZE}/build" ]] && rm -rf "${ORACLIZE}/build"
cd ${ORACLIZE}
truffle compile
truffle migrate --develop --reset
