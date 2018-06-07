#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ORACLIZE="${DIR}/oraclize"
# ***************************************************************
[[ -d "${DIR}/blk-explorer-free" && $(ls -A "${DIR}/blk-explorer-free") != "" ]] \
|| git clone https://github.com/blk-io/blk-explorer-free.git
cd "${DIR}/blk-explorer-free"
NODE_ENDPOINT=http://localhost:22000 docker-compose -f linux-docker-compose.yaml down
NODE_ENDPOINT=http://localhost:22000 docker-compose -f linux-docker-compose.yaml up -d