#!/bin/bash
set -e
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
