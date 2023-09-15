#!/bin/bash
if [ "$#" -lt 1 ]; then 
    echo  "Usage: $0 <numNodes>"
    exit 0; 
fi

numNodes=$1

ssh="ssh -o StrictHostKeyChecking=accept-new"
scp="scp -o StrictHostKeyChecking=accept-new" 

for i in $(seq 1 $numNodes)
do
    $ssh node$i "\
    sudo apt-get -q --assume-yes update > /dev/null; \
    sudo apt-get -q --assume-yes install htop > /dev/null; \
    sudo apt-get -q --assume-yes install openjdk-11-jre-headless > /dev/null; \
    sudo apt-get -q --assume-yes install golang-go > /dev/null; \
    sudo apt-get -q --assume-yes install ant > /dev/null; \
    sudo apt-get -q --assume-yes install gnuplot-nox > /dev/null; \
    echo node$i done!;" &
done