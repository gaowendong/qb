'use strict';
var fs = require('fs');
var Web3 = require('web3');
var web3 = new Web3(Web3.givenProvider || "http://localhost:22000");
// web3.eth.net.getPeerCount().then(result => {
//     console.log(result);
// }).catch(err => {
//     console.log(err);
// });
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
var address = "0xa501afd7d6432718daf4458cfae8590d88de818e";
var abi = JSON.parse(fs.readFileSync("./oraclize/build/contracts/OraclizeTest.json")).abi;
// console.log(abi);
var myContractInstance = new web3.eth.Contract(abi, address, {
    from: '0xed9d02e382b34818e88b88a309c7fe71e65f419d',
    // data: '',
    gasPrice: '0',
    gas: 4500000,
});
// var myContractInstance = web3.eth.Contract(abi).at(address);

console.log(myContractInstance.options);
myContractInstance.once('LogUpdate', {
    // filter: { myIndexedParam: [20, 23], myOtherIndexedParam: '0x123456789...' },
    fromBlock: 0, toBlock: 'latest'
}, function (error, event) {
    console.log(event);
});

myContractInstance.events.LogInfo({ fromBlock: 0, toBlock: 'latest' }, function (error, event) {
    console.log(event);
});

myContractInstance.events.allEvents({ fromBlock: 0, toBlock: 'latest' }, function (error, event) {
    console.log(event);
});