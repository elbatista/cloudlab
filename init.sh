#!/bin/bash
if [ "$#" -lt 2 ]; then 
    echo  "Usage: $0 <node0> <numNodes>"
    exit 0; 
fi

node0=$1
numNodes=$2
projects=("flex"); #"bplusavl"

ssh="ssh -o StrictHostKeyChecking=accept-new"
scp="scp -o StrictHostKeyChecking=accept-new" 

# send ssh config files to node0
$scp -r ~/.ssh/sshcloudlab batista@$node0:~/
$scp -r ~/.ssh/sshcloudlab/config batista@$node0:~/.ssh/config
$ssh $node0 "sudo chmod 700 ~/sshcloudlab; sudo chmod 600 ~/sshcloudlab/id_*; sudo chmod 644 ~/sshcloudlab/*.pub; sudo chmod +x ~/.ssh/config"

git config --global user.name Elia
git config --global user.email delime@usi.ch

# install basics on node0
$ssh $node0 " \
sudo apt-get -qq --assume-yes update; \
sudo apt-get -qq --assume-yes install htop; \
sudo apt-get -qq --assume-yes install openjdk-11-jre-headless; \
sudo apt-get -qq --assume-yes install golang-go;"

# send script to init all other nodes
$scp -r ./initworkers.sh batista@$node0:~/
$ssh $node0 "~/initworkers.sh $numNodes"

#clone project respositories
if [[ $(echo ${projects[@]} | fgrep -w "flex") ]]
then
    echo cloning flexcast;
    $ssh $node0 "cd ~; if [ ! -d \"~/flexcast\" ]; then git clone git@github.com:elbatista/flexcast.git; fi"
fi
