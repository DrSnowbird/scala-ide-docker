FROM openkbs/jre-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG SCALA_IDE_VERSION=${SCALA_IDE_VERSION:-"4.6.1"}
ENV SCALA_IDE_VERSION=${SCALA_IDE_VERSION}

ENV SCALA_VERSION=2.12.2
ENV SBT_VERSION=0.13.15

## ---- USER_NAME is defined in parent image: openkbs/jre-mvn-py3-x11 already ----
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}

# Scala expects this file
#RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release
    
## ---- Install Scala ----
## Piping curl directly in tar
WORKDIR /usr/local
RUN wget -c http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz && \
    tar xvf scala-${SCALA_VERSION}.tgz && \
    rm scala-${SCALA_VERSION}.tgz && \
    ls /usr/local && \
    echo ${JAVA_HOME} && \
    echo >> ${HOME}/.bashrc && \
    echo "export PATH=/usr/local/scala-${SCALA_VERSION}/bin:$PATH" >> ${HOME}/.bashrc

## ---- Install sbt ----
WORKDIR /tmp
RUN apt-get install -y apt-transport-https ca-certificates libcurl3-gnutls && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install -y sbt
    
WORKDIR ${HOME}
# http://downloads.typesafe.com/scalaide-pack/4.6.1-vfinal-neon-212-20170609/scala-SDK-4.6.1-vfinal-2.12-linux.gtk.x86_64.tar.gz
RUN wget -c http://downloads.typesafe.com/scalaide-pack/4.6.1-vfinal-neon-212-20170609/scala-SDK-4.6.1-vfinal-2.12-linux.gtk.x86_64.tar.gz && \
    tar xvf scala-SDK-4.6.1-vfinal-2.12-linux.gtk.x86_64.tar.gz 

RUN mkdir -p ${HOME}/workspace
VOLUME ${HOME}/workspace
    
USER ${USER_NAME}

CMD "${HOME}/eclipse/eclise"
