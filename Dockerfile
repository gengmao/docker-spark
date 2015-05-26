FROM java:8

# Install maven
RUN apt-get -y update && \
    apt-get -y install maven && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# Set base spark vars
ENV SPARK_VERSION 1.2.2
ENV SPARK_HOME /usr/local/spark

# Download and compile Apache Spark
RUN mkdir /src && \
    cd /src && \
    wget http://apache-mirror.rbc.ru/pub/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz && \
    tar -xf spark-$SPARK_VERSION.tgz && \
    cd /src/spark-$SPARK_VERSION && \
    dev/change-version-to-2.11.sh && \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 ./make-distribution.sh --name spark --skip-java-test -Dscala-2.11 && \
    mv dist $SPARK_HOME && \
    rm -rf /src /root/*
