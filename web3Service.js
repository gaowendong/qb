'use strict';
var fs = require('fs');
var Web3 = require('web3');
var web3 = new Web3(Web3.givenProvider || "http://localhost:22000");
web3.eth.net.getPeerCount().then(result => {
    console.log(result);
}).catch(err => {
    console.log(err);
});
// web3.eth.getCode("0x1932c48b2bf8102ba33b4a6b545c32236e342f34").then(result => {
//     console.log(result);
// }).catch(err => {
//     console.log(err);
// });
var blockHash = '0x38fb78794dce2a007d322c0e83999a8c676a8d9decee7636be3efb2fdcddafb6';
// web3.eth.getBlock(blockHash).then(result => {
//     console.log(result);
// }).catch(err => {
//     console.log(err);
// });
// web3.eth.getTransaction(blockHash).then(result => {
//     console.log(result);
//     // console.log(result.input);
// }).catch(err => {
//     console.log(err);
// });
var abi = JSON.parse(fs.readFileSync("./oraclize/build/contracts/Users.json")).abi;
console.log(abi);
var myContractInstance = new web3.eth.Contract(abi, "0x1932c48b2bf8102ba33b4a6b545c32236e342f34");
// var myContractInstance = web3.eth.Contract(abi).at('0x1932c48b2bf8102ba33b4a6b545c32236e342f34');
myContractInstance.once('LogInfo', {
    // filter: { myIndexedParam: [20, 23], myOtherIndexedParam: '0x123456789...' },
    fromBlock: 0
}, function (error, event) {
    console.log(event);
});