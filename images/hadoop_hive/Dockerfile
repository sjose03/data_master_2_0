FROM openjdk:8-jdk-slim

# Variaveis de ambiente do Hadoop
ENV HADOOP_VERSION 3.2.4
ENV HADOOP_MINOR_VERSION 3.2
ENV HIVE_VERSION 3.1.3
ENV HIVE_HOME=/usr/hive
ENV HIVE_PORT 10000
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin
ENV CLASSPATH=$HIVE_HOME/lib


USER root


# Ajustes e instalação dos componentes do hadoop
RUN apt-get update \
    && apt-get install -y wget vim ssh openssh-server curl sudo iputils-ping \
    build-essential libssl-dev libffi-dev libpq-dev \
    # Hadoop
    && wget \
    "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    && tar zvxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/ \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && rm -rf ${HADOOP_HOME}/share/doc \
    && chown -R root:root ${HADOOP_HOME} \
    # Hive
    && wget \
    https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && tar zxvf apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && rm apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && mv apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} \
    && cp ${HIVE_HOME}/conf/hive-env.sh.template ${HIVE_HOME}/conf/hive-env.sh \
    && echo "export HADOOP_HOME=/usr/hadoop-${HADOOP_VERSION}/" >> ${HIVE_HOME}/conf/hive-env.sh \
    && wget \
    https://jdbc.postgresql.org/download/postgresql-42.6.0.jar \
    && mv postgresql-42.6.0.jar postgresql-jdbc.jar \
    # Configurando o conector do metastore do Hive
    && ln -s postgresql-jdbc.jar ${HIVE_HOME}/lib/postgresql-jdbc.jar \
     # Criando diretório para jars externos do Hive e baixando suporte a parquet
    && wget https://repo1.maven.org/maven2/com/twitter/parquet-avro/1.2.5/parquet-avro-1.2.5.jar -P /usr/hive/aux_jars/ \
    # Configurando o JAVA_HOME para os processos localizarem a instalação do Java
    && echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment \
    && rm ${HIVE_HOME}/lib/guava-19.0.jar \
    && cp ${HADOOP_HOME}/share/hadoop/hdfs/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/



# Keys dos nodes. Necessarias para se comunicarem por SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys
COPY /configs/config /root/.ssh
RUN chmod 600 /root/.ssh/config

# Todos os arquivos de configuracao que devem ser copiados para dentro do
# container estao aqui
COPY configs/hadoop/*.xml /usr/hadoop-${HADOOP_VERSION}/etc/hadoop/
COPY configs/hive/*.xml ${HIVE_HOME}/conf/

COPY configs/scripts /

# Portas 10000:10002 relativas ao Hiveserver2 
# Portas 2181 2888 e 3888 relativas ao Zookeper, 9092 ao Kafka, 9999 webui do Hiveserver
EXPOSE 9000 4040 8020 22 9083 9870 10000 10001 10002 9999 50070

# Algumas configuracoes adicionais e inicio de alguns servicoes que devem ser feitos em
# tempo de execucao estao presentes no script bootstrap.
# Este cuidará de colocar alguns datasets exemplo dentro do HDFS, bem como de iniciar 
# servicos como HDFS (formatando Namenode), iniciando o Hive, definindo o ID do 
# Zookeeper para que suas diferentes instâncias possam se ver e iniciando este servico.
# O comando ENTRYPOINT define que este script será executado quando os containeres
# iniciarem.
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]
