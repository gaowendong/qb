#!/bin/bash
set -e

read -p "Deploying in virtualbox ? [Y/n]" var
if [[ "${var}" != "Y" ]]; then
: <<'COMMIT'
su root
# userdel -rf zj
useradd vagrant -m -s `which bash`
chmod u+x /etc/sudoers
sudo -e /etc/sudoers
# modify
# vagrant ALL=(ALL:ALL) ALL
chmod u-x /etc/sudoers
cd /home/vagrant
curl -sLf https://raw.githubusercontent.com/jpmorganchase/quorum-examples/master/vagrant/bootstrap.sh | bash
# error info
# cp: cannot stat '/vagrant/examples': No such file or directory
passwd vagrant
su vagrant
curl -sLf https://raw.githubusercontent.com/fogetIt/qb/master/7nodes.sh | sudo bash
COMMIT
    if [[ ! -d /home/vagrant/examples ]]; then
        mkdir /home/vagrant/examples
        git clone https://github.com/jpmorganchase/quorum-examples.git /home/vagrant/examples
    fi
    cp -r /home/vagrant/examples/examples /home/vagrant/quorum-examples
    sudo chown -R vagrant:vagrant /home/vagrant/quorum /home/vagrant/quorum-examples
fi
: <<'COMMIT'
git clone https://github.com/jpmorganchase/quorum-examples
cd quorum-examples
vagrant up
vagrant ssh
COMMIT
set +e
killall -w -9 geth bootnode constellation-node
set -e
cd "${HOME}/quorum-examples/7nodes"
./raft-init.sh
./raft-start.sh
