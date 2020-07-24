#!/bin/bash
set -e

source /etc/profile
export JAVA_HOME=/usr/java/latest
export PATH=$JAVA_HOME/bin:$PATH
touch /tmp/node.log
chown admin: /tmp/node.log
chown admin: /home/admin/node
host=$(hostname -i)

if [ -z "${MANAGER_ADDRESS}" ]; then
  MANAGER_ADDRESS="127.0.0.1:8081"
fi
if [ -z "${NID}" ]; then
  NID=1
fi

function checkStart() {
  local name=$1
  local cmd=$2
  local timeout=$3
  cost=5
  while [ $timeout -gt 0 ]; do
    ST=$(eval $cmd)
    if [ "$ST" == "0" ]; then
      sleep 1
      let timeout=timeout-1
      let cost=cost+1
    elif [ "$ST" == "" ]; then
      sleep 1
      let timeout=timeout-1
      let cost=cost+1
    else
      break
    fi
  done
  echo "$name start successful"
}

function start_node() {
  echo "start node ..."
  # start node
  cmd="sed -i -e 's/^otter.manager.address.*$/otter.manager.address = ${MANAGER_ADDRESS}/' /home/admin/node/conf/otter.properties"
  eval $cmd

  su admin -c 'cd /home/admin/node/bin/ && echo '${NID}'> /home/admin/node/conf/nid && sh startup.sh 1>>/tmp/node.log 2>&1'
  sleep 5
  #check start
  checkStart "node" "nc 127.0.0.1 2088 -w 1 -z | wc -l" 30
}

function stop_node() {
  # stop node
  echo "stop node"
  su admin -c 'cd /home/admin/node/bin/ && sh stop.sh'
  echo "stop node successful ..."
}

echo "==> START ..."
start_node
echo "==> START SUCCESSFUL ..."
