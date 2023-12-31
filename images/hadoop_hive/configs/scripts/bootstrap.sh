#!/bin/bash

# Este trecho rodará independente de termos um container master ou
# worker. Necesário para funcionamento do HDFS e para comunicação
# dos containers/nodes.
/etc/init.d/ssh start

export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
useradd -g sudo jose
useradd -g sudo hue
useradd -g sudo hive

# Formatamos o namenode
hdfs namenode -format

# Iniciamos os serviços do hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

# Iniciamos os serviços do hive
schematool -dbType postgres -initSchema
hdfs dfs -mkdir /datasets
hdfs dfs -mkdir /datasets_processed
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hue
hdfs dfs -mkdir /user/jose
hdfs dfs -chown -R jose:root /user/jose
hdfs dfs -chown -R hue:root /user/hue
hdfs dfsadmin -refreshUserToGroupsMappings
echo 'ligando o hive'
nohup hive --service metastore > /dev/null 2>&1 &
nohup hive --service hiveserver2 > /dev/null 2>&1 &


while :; do sleep 2073600; done
