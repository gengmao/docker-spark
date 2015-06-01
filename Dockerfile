FROM java:8

# Set Maven vars
ENV MAVEN_VERSION 3.0.5
ENV MAVEN_HOME /usr/share/maven

# Install Maven
RUN mkdir /src && \
    cd /src && \
    wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -xf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv /src/apache-maven-$MAVEN_VERSION $MAVEN_HOME && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin/mvn && \
    rm -rf /src

# Set base Spark vars
ENV SPARK_VERSION 1.3.1
ENV SPARK_HOME /usr/local/spark

# Download and compile Apache Spark
RUN mkdir /src && \
    cd /src && \
    wget http://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz && \
    tar -xf spark-$SPARK_VERSION.tgz && \
    cd /src/spark-$SPARK_VERSION && \
    dev/change-version-to-2.11.sh && \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 ./make-distribution.sh --name spark --skip-java-test -Dscala-2.11 && \
    mv dist $SPARK_HOME && \
    rm -rf /src /root/*

# Add Spark configs
ADD conf/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

# Add Spark startup scripts
ADD bin/spark-master /usr/local/bin/spark-master
ADD bin/spark-worker /usr/local/bin/spark-worker
ADD bin/spark-shell  /usr/local/bin/spark-shell

# Set misc Spark vars
ENV SPARK_MASTER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"
ENV SPARK_WORKER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_PORT 8888
ENV SPARK_WORKER_WEBUI_PORT 8081

EXPOSE 8080 7077 8888 8081 4040 7001 7002 7003 7004 7005 7006
