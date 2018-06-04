'use strict';
// const https = require('https');
const config = require('config');
// const moment = require('moment');
const log4js = require('log4js');


const CONFIG = config.get('Config');
exports.CONFIG = CONFIG;

exports.Logger = (loggerName, useJson = false) => {
    if (useJson) {
        log4js.configure(CONFIG.log4js);
    }
    return log4js.getLogger(loggerName);
};

exports.isEmptyObject = obj => {
    return obj === null || JSON.stringify(obj) === '{}';
};

exports.isEmptyArray = arr => {
    return arr.length === 0;
};

// exports.request = options => {
//     return new Promise((resolve, reject) => {
//         let req = https.request(options, (res) => {
//             res.setEncoding('utf-8');
//     let d = '';
//         res.on('data', (data) => {
//             d += data;
//     });
//         res.on('end', () => {
//             resolve(d);
//     });
//         res.on('error', (data) => {
//             reject(data);
//     });
//     });
//         req.end();
//     });
// };


exports.getUserId = req => {
    return req.session.user ? req.session.user.id: 0;
};


exports.checkSession = (req, key) => {
    const value = req.session.user ? req.session.user[key]: 0;
    return value !== 0;
};


/**
 * '2018-01-07' -> 1515254400
 * '1515254400' -> 1515254400
 */
// exports.getTimestamp = stringTime => {
//     const maxMysqlInt = 4294967295;
//     let timestamp = stringTime ? (
//         isNaN(stringTime) ? moment(stringTime).unix() : Number(stringTime)
//     ) : 0;
//     if (timestamp >= maxMysqlInt) {
//         return null;
//     }
//     return timestamp;
// };