FROM openkbs/jre-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG SCALA_IDE_VERSION=${SCALA_IDE_VERSION:-"4.6.1"}
ENV SCALA_IDE_VERSION=${SCALA_IDE_VERSION}

#Eclipse 4.7.1 (Oxygen)
#Scala IDE 4.7.0
#Scala 2.12.3 with Scala 2.11.11 and Scala 2.10.6
#Zinc 1.0.0
#Scala Worksheet 0.7.0
#ScalaTest 2.10.0.v-4-2_12
#Scala Refactoring 0.13.0
#Scala Search 0.6.0
#Scala IDE Play2 Plugin 0.10.0
#Scala IDE Lagom Plugin 1.0.0

ENV SCALA_VERSION=2.12.3
ENV SBT_VERSION=0.13.15

## ---- USER_NAME is defined in parent image: openkbs/jre-mvn-py3-x11 already ----
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}

# Scala expects this file
#RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release
    
############################
#### ---- Install Scala ----
############################
#### Piping curl directly in tar
ENV SCALA_INSTALL_BASE=/usr/local
WORKDIR ${SCALA_INSTALL_BASE}
# https://downloads.lightbend.com/scala/2.12.3/scala-2.12.3.tgz
RUN wget -c https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz && \
    tar xvf scala-${SCALA_VERSION}.tgz && \
    rm scala-${SCALA_VERSION}.tgz && \
    ls /usr/local && \
    echo "#!/bin/bash" > /etc/profile.d/scala.sh && \
    echo "export SCALA_VERSION=${SCALA_VERSION}" >> /etc/profile.d/scala.sh && \
    echo "export SCALA_HOME=${SCALA_INSTALL_BASE}/scala-${SCALA_VERSION}" >> /etc/profile.d/scala.sh && \
    echo "export PATH=${SCALA_INSTALL_BASE}/scala-${SCALA_VERSION}/bin:$PATH" >> /etc/profile.d/scala.sh && \
    echo "export CLASSPATH=\${SCALA_HOME}/bin:\$CLASSPATH" >> /etc/profile.d/scala.sh

#ENV SCALA_INSTALL_BASE=/usr/lib
#WORKDIR ${SCALA_INSTALL_BASE}
#RUN wget -c https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb && \
#    sudo apt-get install -y scala-${SCALA_VERSION}.deb && \
#    rm scala-${SCALA_VERSION}.deb && \
#    ls ${SCALA_INSTALL_BASE} && \
#    echo "#!/bin/bash" > /etc/profile.d/scala.sh && \
#    echo "export SCALA_VERSION=${SCALA_VERSION}" >> /etc/profile.d/scala.sh
#    echo "export SCALA_HOME=/usr/lib/scala-${SCALA_VERSION}" >> /etc/profile.d/scala.sh
#    echo "export PATH=${SCALA_INSTALL_BASE}/scala-${SCALA_VERSION}/bin:$PATH" >> /etc/profile.d/scala.sh
#    echo "export CLASSPATH=\$SCALA_HOME/bin:\$CLASSPATH" >> /etc/profile.d/scala.sh

##########################
#### ---- Install sbt ----
##########################
WORKDIR /tmp
RUN apt-get install -y apt-transport-https ca-certificates libcurl3-gnutls && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install -y sbt
    
WORKDIR ${HOME}
# http://downloads.typesafe.com/scalaide-pack/4.6.1-vfinal-neon-212-20170609/scala-SDK-4.6.1-vfinal-2.12-linux.gtk.x86_64.tar.gz
#####################################
#### ---- MODIFY two lines below ----
#####################################
ENV SCALA_IDE_TAR=scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz
ENV SCALA_IDE_DOWNLOAD_FOLDER=4.7.0-vfinal-oxygen-212-20170929
## -- (Release build) --
# http://downloads.typesafe.com/scalaide-pack/4.7.0-vfinal-oxygen-212-20170929/scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz
RUN wget -c http://downloads.typesafe.com/scalaide-pack/${SCALA_IDE_DOWNLOAD_FOLDER}/${SCALA_IDE_TAR} && \
    tar xvf ${SCALA_IDE_TAR} && \
    rm ${SCALA_IDE_TAR}
## -- (Local build) --
#COPY scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz ./
#RUN tar xvf ${SCALA_IDE_TAR} && \
#    rm ${SCALA_IDE_TAR}

RUN mkdir -p ${HOME}/workspace
VOLUME ${HOME}/workspace
    
USER ${USER_NAME}

CMD "${HOME}/eclipse/eclipse"
