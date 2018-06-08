### [start quorum 7nodes](./7nodes)

### start oraclize response service and run blk-explorer-free with host
```bash
./prereqs-ubuntu.sh ${NODE_HOST}
```

### run etherum-bridge with host
```bash
ethereum-bridge -a 0 --gasprice 0 --dev --skip --disable-price -H ${NODE_HOST} -p 22000
docker restart $(docker ps -a -q)
```

### deploy contract with OAR
```bash
# 0x6f485c8bf6fc43ea212e93bbf8ce046c7f1cb475
./deploy.sh ${OAR}
```
