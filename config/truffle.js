module.exports = {
    // 代表某个节点部署合约
    networks: {
        development: {
            host: "127.0.0.1",
            port: 22000,
            gasPrice: 0,
            gas: 4500000,
            // 7nodes/keys/key2
            // from: "ca843569e3427144cead5e4d5999a3d0ccf92b8e",
            network_id: "*" // match any network
        },
    }
};
