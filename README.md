# Docker image for Apache Spark cluster

This repo contains an docker image to run Apache Spark with Hadoop and Mesos. It could be used as a `spark.mesos.executor.docker.image`.  

It uses Apache Spark compiled from source for Scala 2.11 on OpenJDK 7 with Hadoop 2.6. The image includes Mesos 0.25 too.  

# Other Spark images

This repo is partly based on following:
* https://github.com/alno/docker-spark
* https://github.com/mesosphere/docker-containers/blob/master/mesos/dockerfile-templates/mesos
