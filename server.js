'use strict';
const fs = require('fs');
const Koa = require('koa');
const Json = require('koa-json');
const Send = require('koa-send');

const app = new Koa();
const PORT = 8765;

const JSONARRAY = [
    { date: "2008-06-05", open: "881.290", high: "883.290", low: "867.290", close: "881.290", volume: "4" },
    { date: "2008-06-06", open: "882.700", high: "905.290", low: "880.790", close: "904.700", volume: "8048" },
    { date: "2008-06-09", open: "905.500", high: "912.290", low: "893.500", close: "895.290", volume: "6790" },
    { date: "2008-06-10", open: "894.000", high: "897.290", low: "866.790", close: "869.500", volume: "10214" },
    { date: "2008-06-11", open: "871.200", high: "885.900", low: "869.500", close: "883.090", volume: "11861" },
    { date: "2008-06-12", open: "883.500", high: "884.900", low: "859.700", close: "870.900", volume: "10595" },
    { date: "2008-06-13", open: "871.290", high: "876.700", low: "861.500", close: "873.700", volume: "11784" },
    { date: "2008-06-16", open: "872.590", high: "897.200", low: "868.900", close: "884.200", volume: "8347" },
    { date: "2008-06-17", open: "884.590", high: "891.000", low: "876.290", close: "884.500", volume: "9826" },
    { date: "2008-06-18", open: "884.900", high: "898.090", low: "882.500", close: "893.400", volume: "10571" },
    { date: "2008-06-19", open: "894.500", high: "898.090", low: "893.000", close: "895.500", volume: "2349" },
    { date: "2008-06-20", open: "900.290", high: "910.290", low: "897.400", close: "903.700", volume: "7738" },
    { date: "2008-06-23", open: "904.500", high: "909.290", low: "877.500", close: "886.000", volume: "20001" },
    { date: "2008-06-24", open: "886.000", high: "896.290", low: "884.590", close: "891.590", volume: "17237" },
    { date: "2008-06-25", open: "891.590", high: "892.290", low: "875.290", close: "887.500", volume: "20068" },
    { date: "2008-06-26", open: "882.000", high: "916.290", low: "879.590", close: "915.000", volume: "19824" },
    { date: "2008-06-27", open: "913.000", high: "931.290", low: "912.200", close: "929.790", volume: "19487" },
    { date: "2008-06-30", open: "930.900", high: "937.290", low: "920.200", close: "928.900", volume: "18663" },
    { date: "2008-07-01", open: "928.000", high: "948.290", low: "923.900", close: "944.700", volume: "21865" },
    { date: "2008-07-02", open: "941.700", high: "947.790", low: "933.500", close: "947.200", volume: "22729" },
    { date: "2008-07-03", open: "946.590", high: "949.790", low: "928.590", close: "935.400", volume: "19734" },
    { date: "2008-07-04", open: "935.900", high: "938.290", low: "930.790", close: "935.700", volume: "6366" },
    { date: "2008-07-07", open: "934.500", high: "935.700", low: "916.400", close: "927.590", volume: "23078" },
    { date: "2008-07-08", open: "927.700", high: "935.290", low: "913.590", close: "921.200", volume: "14049" },
    { date: "2008-07-09", open: "921.700", high: "930.290", low: "917.290", close: "929.590", volume: "18226" },
    { date: "2008-07-10", open: "929.700", high: "949.200", low: "924.900", close: "947.700", volume: "19915" },
    { date: "2008-07-11", open: "946.590", high: "969.000", low: "942.590", close: "965.400", volume: "21366" },
    { date: "2008-07-14", open: "966.790", high: "976.400", low: "954.500", close: "973.290", volume: "20241" },
    { date: "2008-07-15", open: "974.200", high: "989.400", low: "968.700", close: "978.290", volume: "18635" },
    { date: "2008-07-16", open: "978.500", high: "982.400", low: "958.290", close: "960.290", volume: "22213" },
    { date: "2008-07-17", open: "960.090", high: "979.790", low: "953.400", close: "957.900", volume: "29719" },
    { date: "2008-07-18", open: "958.400", high: "965.000", low: "950.290", close: "955.400", volume: "17485" },
    { date: "2008-07-21", open: "957.290", high: "968.900", low: "955.700", close: "966.500", volume: "14811" },
    { date: "2008-07-22", open: "966.590", high: "977.000", low: "942.400", close: "945.500", volume: "21469" },
    { date: "2008-07-23", open: "946.000", high: "949.290", low: "917.500", close: "920.200", volume: "30028" },
    { date: "2008-07-24", open: "920.790", high: "931.400", low: "915.900", close: "927.200", volume: "25376" },
    { date: "2008-07-25", open: "927.590", high: "935.200", low: "918.500", close: "929.200", volume: "16139" },
    { date: "2008-07-28", open: "929.000", high: "932.900", low: "920.200", close: "930.290", volume: "16752" },
    { date: "2008-07-29", open: "930.000", high: "933.000", low: "913.500", close: "918.290", volume: "10071" },
    { date: "2008-07-30", open: "918.000", high: "919.090", low: "893.290", close: "905.590", volume: "9545" },
    { date: "2008-07-31", open: "906.790", high: "925.590", low: "905.590", close: "913.090", volume: "8839" },
    { date: "2008-08-01", open: "904.900", high: "916.090", low: "902.090", close: "910.290", volume: "8107" },
    { date: "2008-08-04", open: "917.790", high: "919.000", low: "897.790", close: "898.500", volume: "7208" },
    { date: "2008-08-05", open: "898.900", high: "899.400", low: "876.500", close: "877.400", volume: "1000" },
    { date: "2008-08-06", open: "878.000", high: "890.090", low: "876.900", close: "883.290", volume: "917" },
    { date: "2008-08-07", open: "883.700", high: "888.400", low: "870.790", close: "875.000", volume: "3782" },
    { date: "2008-08-08", open: "875.400", high: "877.290", low: "853.790", close: "859.290", volume: "5446" },
    { date: "2008-08-11", open: "861.200", high: "868.500", low: "821.700", close: "825.790", volume: "5863" },
    { date: "2008-08-12", open: "825.090", high: "829.590", low: "804.590", close: "814.290", volume: "7189" },
    { date: "2008-08-13", open: "814.400", high: "832.400", low: "809.000", close: "829.200", volume: "6559" },
    { date: "2008-08-14", open: "828.900", high: "838.900", low: "806.790", close: "807.590", volume: "15971" },
    { date: "2008-08-15", open: "808.790", high: "808.790", low: "775.000", close: "788.400", volume: "13145" },
    { date: "2008-08-18", open: "792.590", high: "805.900", low: "788.400", close: "801.000", volume: "4079" },
    { date: "2008-08-19", open: "800.400", high: "819.000", low: "784.200", close: "815.500", volume: "3533" },
    { date: "2008-08-20", open: "819.200", high: "820.000", low: "801.700", close: "814.900", volume: "6602" },
    { date: "2008-08-21", open: "815.200", high: "841.090", low: "814.900", close: "838.500", volume: "2908" },
    { date: "2008-08-22", open: "834.200", high: "839.590", low: "822.590", close: "825.090", volume: "4137" },
    { date: "2008-08-25", open: "819.590", high: "827.200", low: "817.200", close: "823.290", volume: "3119" },
    { date: "2008-08-26", open: "824.000", high: "831.290", low: "808.090", close: "824.790", volume: "2069" },
    { date: "2008-08-27", open: "823.700", high: "836.500", low: "823.500", close: "828.000", volume: "2514" },
    { date: "2008-08-28", open: "829.500", high: "845.700", low: "827.400", close: "833.590", volume: "2771" },
    { date: "2008-08-29", open: "837.000", high: "840.090", low: "831.000", close: "832.090", volume: "2140" },
    { date: "2008-09-01", open: "838.090", high: "838.090", low: "816.000", close: "818.400", volume: "2841" },
    { date: "2008-09-02", open: "817.200", high: "820.900", low: "791.700", close: "806.200", volume: "2612" },
    { date: "2008-09-03", open: "810.700", high: "813.500", low: "793.700", close: "808.200", volume: "8" },
    { date: "2008-09-04", open: "801.900", high: "815.300", low: "794.400", close: "799.300", volume: "900" },
    { date: "2008-09-05", open: "794.200", high: "820.300", low: "791.200", close: "798.800", volume: "1257" },
    { date: "2008-09-08", open: "815.500", high: "818.500", low: "797.200", close: "798.500", volume: "993" },
    { date: "2008-09-09", open: "801.400", high: "805.600", low: "776.100", close: "788.100", volume: "1330" },
    { date: "2008-09-10", open: "777.200", high: "783.800", low: "751.500", close: "758.900", volume: "1309" },
    { date: "2008-09-11", open: "752.300", high: "757.900", low: "736.400", close: "742.100", volume: "1175" },
    { date: "2008-09-12", open: "748.400", high: "766.400", low: "746.000", close: "761.000", volume: "901" },
    { date: "2008-09-15", open: "770.000", high: "787.900", low: "764.400", close: "783.800", volume: "1104" },
    { date: "2008-09-16", open: "788.000", high: "790.300", low: "772.500", close: "777.100", volume: "929" },
    { date: "2008-09-17", open: "774.800", high: "869.200", low: "774.800", close: "847.100", volume: "1579" },
    { date: "2008-09-18", open: "861.400", high: "922.000", low: "833.100", close: "893.200", volume: "2410" },
    { date: "2008-09-19", open: "853.000", high: "877.900", low: "824.500", close: "861.000", volume: "855" },
    { date: "2008-09-22", open: "877.000", high: "908.200", low: "864.000", close: "904.300", volume: "806" },
    { date: "2008-09-23", open: "902.200", high: "910.000", low: "880.300", close: "885.900", volume: "738" },
    { date: "2008-09-24", open: "889.900", high: "902.100", low: "876.000", close: "889.400", volume: "680" },
    { date: "2008-09-25", open: "883.000", high: "894.400", low: "864.100", close: "878.000", volume: "869" },
    { date: "2008-09-26", open: "879.100", high: "910.500", low: "867.800", close: "882.900", volume: "558" },
    { date: "2008-09-29", open: "871.300", high: "919.000", low: "866.400", close: "888.200", volume: "374" },
    { date: "2008-09-30", open: "904.800", high: "912.500", low: "855.000", close: "874.200", volume: "72" },
    { date: "2008-10-01", open: "878.000", high: "889.100", low: "869.200", close: "880.700", volume: "50" },
    { date: "2008-10-02", open: "876.200", high: "881.600", low: "833.500", close: "844.300", volume: "146" },
    { date: "2008-10-03", open: "841.000", high: "852.700", low: "822.500", close: "833.200", volume: "35736" },
    { date: "2008-10-06", open: "836.000", high: "879.000", low: "828.400", close: "866.200", volume: "7441" },
    { date: "2008-10-07", open: "859.100", high: "893.700", low: "858.000", close: "882.000", volume: "26312" },
    { date: "2008-10-08", open: "890.900", high: "924.900", low: "880.200", close: "906.500", volume: "37694" },
    { date: "2008-10-09", open: "910.200", high: "929.000", low: "882.900", close: "886.500", volume: "20800" },
    { date: "2008-10-10", open: "915.200", high: "936.300", low: "829.000", close: "859.000", volume: "52932" },
    { date: "2008-10-13", open: "855.800", high: "875.000", low: "824.500", close: "842.500", volume: "26484" },
    { date: "2008-10-14", open: "835.200", high: "857.400", low: "833.600", close: "839.500", volume: "24269" },
    { date: "2008-10-15", open: "837.900", high: "859.200", low: "833.100", close: "839.000", volume: "25105" },
    { date: "2008-10-16", open: "851.000", high: "852.100", low: "786.700", close: "804.500", volume: "34030" },
    { date: "2008-10-17", open: "807.400", high: "816.900", low: "772.200", close: "787.700", volume: "23664" },
    { date: "2008-10-20", open: "784.600", high: "811.800", low: "782.800", close: "790.000", volume: "19274" },
    { date: "2008-10-21", open: "798.000", high: "805.000", low: "766.400", close: "768.000", volume: "23732" },
    { date: "2008-10-22", open: "773.600", high: "777.900", low: "720.000", close: "735.200", volume: "31747" },
    { date: "2008-10-23", open: "730.000", high: "735.200", low: "695.200", close: "714.700", volume: "32618" },
    { date: "2008-10-24", open: "724.700", high: "750.400", low: "681.000", close: "730.300", volume: "36776" }
];

app.use(Json());
app.use(async (ctx, next) => {
    const fileName = 'response.json';
    let result = {"data": JSONARRAY[Math.floor(Math.random() * 100 + 1)]};
    // let result = { "data": { "base": "ETH", "currency": "USD", "amount": "606.57" } };
    await fs.writeFile('./' + fileName, JSON.stringify(result), err => {
        if (err) {
            console.error(err);
        }
        console.log('write success');
    });
    ctx.attachment(fileName);
    await Send(ctx, fileName, { root: __dirname });
    // ctx.body = await result;
});
app.listen(PORT);
console.log("Server started and listen on port " + PORT);
