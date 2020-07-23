#!/bin/bash
set -e

source /etc/profile
export JAVA_HOME=/usr/java/latest
export PATH=$JAVA_HOME/bin:$PATH
touch /zkh/log/manager.log
chown admin: /zkh/log/manager.log
chown admin: /home/admin/manager
host=$(hostname -i)

if [ -z "${OTTER_MANAGER_MYSQL}" ]; then
  OTTER_MANAGER_MYSQL="127.0.0.1:3306"
fi
if [ -z "${MYSQL_USER}" ]; then
  MYSQL_USER="otter"
fi
if [ -z "${MYSQL_USER_PASSWORD}" ]; then
  MYSQL_USER_PASSWORD="otter"
fi
if [ -z "${OTTER_DOMAIN_NAME}" ]; then
  OTTER_DOMAIN_NAME=${host}
fi
if [ -z "${DEFAULT_ZOOKEEPER_ADDRESS}" ]; then
  DEFAULT_ZOOKEEPER_ADDRESS=${host}
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

function start_manager() {
  echo "start manager ..."
  # start manager
  if [ -n "${OTTER_MANAGER_MYSQL}" ]; then
    cmd="sed -i -e 's/^otter.database.driver.url.*$/otter.database.driver.url = jdbc:mysql:\/\/${OTTER_MANAGER_MYSQL}\/otter/' /home/admin/manager/conf/otter.properties"
    eval $cmd
    cmd="sed -i -e 's/^otter.database.driver.username.*$/otter.database.driver.username = ${MYSQL_USER}/' /home/admin/manager/conf/otter.properties"
    eval $cmd
    cmd="sed -i -e 's/^otter.database.driver.password.*$/otter.database.driver.password = ${MYSQL_USER_PASSWORD}/' /home/admin/manager/conf/otter.properties"
    eval $cmd
    cmd="sed -i -e 's/^otter.communication.manager.port.*$/otter.communication.manager.port = 8081/' /home/admin/manager/conf/otter.properties"
    eval $cmd
    cmd="sed -i -e 's/^otter.domainName.*$/otter.domainName = ${OTTER_DOMAIN_NAME}/' /home/admin/manager/conf/otter.properties"
    eval $cmd
    cmd="sed -i -e 's/^otter.zookeeper.cluster.default.*$/otter.zookeeper.cluster.default = ${DEFAULT_ZOOKEEPER_ADDRESS}/' /home/admin/manager/conf/otter.properties"
    eval $cmd
  fi
  su admin -c "cd /home/admin/manager/bin ; sh startup.sh 1>>/zkh/log/manager.log 2>&1"
  #check start
  sleep 5
  checkStart "manager" "nc 127.0.0.1 8080 -w 1 -z | wc -l" 60
}

function stop_manager() {
  # stop manager
  echo "stop manager"
  su admin -c 'cd /home/admin/manager/bin; sh stop.sh 1>>/zkh/log/manager.log 2>&1'
  echo "stop manager successful ..."
}

echo "==> START ..."
start_manager
echo "you can visit manager link : http://${OTTER_DOMAIN_NAME}:8080/ , just have fun !"

echo "==> START SUCCESSFUL ..."
