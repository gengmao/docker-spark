FROM java:8

RUN apt-get -y update && \
    apt-get -y install maven && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV SPARK_VERSION 1.2.2

RUN mkdir /src && \
    cd /src && \
    wget http://apache-mirror.rbc.ru/pub/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz

RUN cd /src && \
    tar -xf spark-$SPARK_VERSION.tgz && \
    cd /src/spark-$SPARK_VERSION && \
    dev/change-version-to-2.11.sh && \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 ./make-distribution.sh --name spark --skip-java-test -Dscala-2.11 && \
    mv dist /usr/local/spark && \
    rm -rf /src /root/*
