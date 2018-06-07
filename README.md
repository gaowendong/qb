### start quorum, oraclize api service and blk-explorer-free
```bash
./prereqs-ubuntu.sh
```

### etherum-bridge
```bash
# ethereum-bridge -a 0 -H 127.0.0.1 -p 22000 --gasprice 0 --dev
ethereum-bridge -a 0 -H 127.0.0.1 -p 22000 --gasprice 0 --skip
docker restart $(docker ps -a -q)
```

### deploy contract with OAR
```bash
./deploy.sh 0x6f485c8bf6fc43ea212e93bbf8ce046c7f1cb475
```
