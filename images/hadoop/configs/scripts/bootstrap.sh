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

# Formatamos o namenode
hdfs namenode -format

# Iniciamos os serviços
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh




hdfs dfs -mkdir /datasets
hdfs dfs -mkdir /datasets_processed
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hue
hdfs dfs -mkdir /user/jose
# hdfs dfs -chown -R jose:root /user/jose
# hdfs dfs -chown -R hue:root /user/hue
hdfs dfsadmin -refreshUserToGroupsMappings


while :; do sleep 2073600; done
