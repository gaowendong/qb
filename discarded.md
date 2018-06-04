quorum
======
```bash
java -version || sudo apt-fast install openjdk-8-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
source ~/.bashrc
# geth version
# http://truffleframework.com/tutorials/building-dapps-for-quorum-private-enterprise-blockchains
# http://truffle.tryblockchain.org/Truffle-introduce-%E4%BB%8B%E7%BB%8D.html
# http://truffleframework.com/docs/getting_started/javascript-tests
```

###### cakeshop
- 节点监控，端口号 8080
```bash
sudo apt-get install openjdk-8-jdk
# sudo apt-get install tomcat7 jetty8
mkdir data
docker run \
    -d \
    -p 8080:8080 -v "$PWD/data":/opt/cakeshop/data \
    -e JAVA_OPTS="-Dspring.profiles.active=local" \
    -v $HOME/.ethash:/opt/cakeshop/.ethash \
    jpmc/cakeshop
```

##### truffle
```bash
truffle version || npm install truffle -g --registry=https://registry.npm.taobao.org
[[ -d "$(pwd)/proj" ]] || mkdir proj
cd proj
truffle init
# truffle test Migrations.sol
rm -rf ./build/ && truffle compile
truffle develop # -> migrate
truffle migrate
# truffle migrate --network development
```