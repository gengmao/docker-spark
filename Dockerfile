FROM java:7

# Set Maven vars
ENV MAVEN_VERSION 3.3.9
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
ENV SPARK_VERSION 1.6.0
ENV SPARK_HOME /opt/spark
ENV MESOS_VERSION 0.25.0-0.2.70.ubuntu1404

# Download and compile Apache Spark
RUN mkdir /src && \
    cd /src && \
    wget http://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz && \
    tar -xf spark-$SPARK_VERSION.tgz && \
    cd /src/spark-$SPARK_VERSION && \
    dev/change-version-to-2.11.sh && \
    JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 ./make-distribution.sh -Phadoop-2.6 -Phive -Phive-thriftserver -Dscala-2.11 -DskipTests && \
    mv dist $SPARK_HOME && \
    rm -rf /src /root/*

# Download Apache Mesos
RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
  apt-get -y update && \
  apt-get -y install mesos=$MESOS_VERSION && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

