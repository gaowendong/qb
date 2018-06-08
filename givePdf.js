'use strict';
const fs = require('fs');
const Koa = require('koa');
const Send = require('koa-send');

/*
curl -o givePdf.js https://raw.githubusercontent.com/fogetIt/qb/master/givePdf.js
sudo apt -y install build-essential libssl-dev
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
nvm install --lts
nvm use --lts && nvm alias default 'lts/*'
sudo apt update
sudo apt install -y node-gyp
npm install koa koa-send
npm install pm2 -g
pm2 start givePdf.js
*/

const app = new Koa();
const PORT = 8765;

app.use(Json());
app.use(async (ctx, next) => {
    const fileName = 'finance_report.pdf';
    ctx.attachment(fileName);
    await Send(ctx, fileName, { root: __dirname });
});
app.listen(PORT);
console.log("Server started and listen on port " + PORT);
