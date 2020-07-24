#!/bin/bash
set -e

source /etc/profile
export JAVA_HOME=/usr/java/latest
export PATH=$JAVA_HOME/bin:$PATH
touch /tmp/manager.log
chown admin: /tmp/manager.log
chown admin: /home/admin/manager

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

function start_manager() {
  echo "start manager ..."
  # start manager
  su admin -c "cd /home/admin/manager/bin ; sh startup.sh 1>>/tmp/manager.log 2>&1"
  #check start
  sleep 5
  checkStart "manager" "nc 127.0.0.1 8080 -w 1 -z | wc -l" 60
}

function stop_manager() {
  # stop manager
  echo "stop manager"
  su admin -c 'cd /home/admin/manager/bin; sh stop.sh 1>>/tmp/manager.log 2>&1'
  echo "stop manager successful ..."
}

echo "==> START ..."
start_manager
echo "you can visit manager link : http://${OTTER_DOMAIN_NAME}:8080/ , just have fun !"

echo "==> START SUCCESSFUL ..."
