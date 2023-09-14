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
    sudo apt-get -q --assume-yes update; \
    sudo apt-get -q --assume-yes install htop; \
    sudo apt-get -q --assume-yes install openjdk-11-jre-headless; \
    sudo apt-get -q --assume-yes install golang-go; \
    echo node$i done!;" &
done