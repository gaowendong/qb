'use strict';
const Koa = require('koa');
const Json = require('koa-json');

// const kits = require('./kits');
const app = new Koa();
const PORT = 8088;


app.use(Json());
app.use(async (ctx, next) => {
    let json = { "date": "2008-06-10", "open": "894.000", "high": "897.290", "low": "866.790", "close": "869.500", "volume": "10214" };
    // TODO
});
app.listen(PORT);
console.log("Server started and listen on port " + PORT);