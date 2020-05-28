##############################################################################################################################
# The Ubuntu 18.04 with installed components for java continious integration:                                                #
#       linux tools, docker client, docker compose, git, JDK 11, maven, etc.                                                 #
#                                                                                                                            #
# @author nedis                                                                                                              #
##############################################################################################################################
# Build:
# docker build -t rxmicro/ci-java -f ci-java.dockerfile .
#
# Push:
# docker push rxmicro/ci-java
# ----------------------------------------------------------------------------------------------------------------------------
# Run:
## nano ci-script.sh
##
## docker run -it --rm -h server --network host --name ci-server \
##      -v ~/.CI-cache:/root/.m2 -v "$PWD":/tasks -v /var/run/docker.sock:/var/run/docker.sock rxmicro/ci-java ci-script.sh
# ----------------------------------------------------------------------------------------------------------------------------
FROM ubuntu:18.04
# ----------------------------------------------------------------------------------------------------------------------------
# Versions:
# ----------------------------------------------------------------------------------------------------------------------------
ARG WGET_VERSION=1.19.4-1ubuntu2.2
ARG CURL_VERSION=7.58.0-2ubuntu3.8
ARG NANO_VERSION=2.9.3-2
ARG GPUNG2_VERSION=2.2.4-1ubuntu1.2
ARG GIT_VERSION=1:2.17.1-1ubuntu0.7

ARG APT_TRANSPORT_HTTPS_VERSION=1.6.12
ARG CA_CERTIFICATES_VERSION=20180409
ARG SOFTWARE_PROPERTIES_COMMON_VERSION=0.96.24.32.12

ARG DOCKER_VERSION=5:19.03.8~3-0~ubuntu-bionic
ARG DOCKER_COMPOSE_VERSION=1.25.5

ARG AZUL_JDK_VERSION=zulu11.39.15-ca-jdk11.0.7-linux_x64
ARG AZUL_JDK_SHA_256_CHECKSUM=df0de67998ac0c58b3c9e83c86e2a81daca05dc5adc189d942bc5d3f4691e749

ARG MAVEN3_VERSION=3.6.3
ARG MAVEN3_SHA_512_CHECKSUM=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
# ----------------------------------------------------------------------------------------------------------------------------
ARG AZUL_JDK_DOWNLOAD_LINK=https://cdn.azul.com/zulu/bin/${AZUL_JDK_VERSION}.tar.gz
ARG MAVEN3_DOWNLOAD_LINK=https://downloads.apache.org/maven/maven-3/${MAVEN3_VERSION}/binaries/apache-maven-${MAVEN3_VERSION}-bin.tar.gz
ARG DOCKER_COMPOSE_DOWNLOAD_LINK="https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64"
# ----------------------------------------------------------------------------------------------------------------------------
RUN apt update && \
    # Install linux tools
        apt install wget=$WGET_VERSION -y && \
        apt install curl=$CURL_VERSION -y && \
        apt install nano=$NANO_VERSION -y && \
        apt install gnupg2=$GPUNG2_VERSION -y && \
        apt install apt-transport-https=$APT_TRANSPORT_HTTPS_VERSION -y && \
        apt install ca-certificates=$CA_CERTIFICATES_VERSION -y && \
        apt install software-properties-common=$SOFTWARE_PROPERTIES_COMMON_VERSION -y && \
    # Install docker-client
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
        add-apt-repository \
               "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
               $(lsb_release -cs) stable" && \
        apt update && \
        apt install docker-ce-cli=$DOCKER_VERSION -y && \
    # Install docker-compose
        curl -L "$DOCKER_COMPOSE_DOWNLOAD_LINK" -o /bin/docker-compose && \
        chmod +x /bin/docker-compose && \
    # Install git
        apt install git=$GIT_VERSION -y && \
    # Goto /tmp directory
        cd /tmp && \
    # Install JDK
        ## Download and unzip
        wget ${AZUL_JDK_DOWNLOAD_LINK} && \
        echo "$AZUL_JDK_SHA_256_CHECKSUM  ${AZUL_JDK_VERSION}.tar.gz" | sha256sum -c - && \
        tar -xvzf ${AZUL_JDK_VERSION}.tar.gz && \
        ## Move to target dir
        mv ${AZUL_JDK_VERSION} /opt/jdk11 && \
        ## Remove demos and source code
        rm -rf /opt/jdk11/demo && \
        rm -rf /opt/jdk11/lib/src.zip && \
        rm -rf /opt/jdk11/man && \
        rm -rf /opt/jdk11/Welcome.html && \
    # Install Maven
        ## Download and unzip
        wget ${MAVEN3_DOWNLOAD_LINK} && \
        tar -xvzf apache-maven-${MAVEN3_VERSION}-bin.tar.gz && \
        echo "$MAVEN3_SHA_512_CHECKSUM  apache-maven-${MAVEN3_VERSION}-bin.tar.gz" | sha512sum -c - && \
        ## Move to target dir
        mv apache-maven-${MAVEN3_VERSION}/ /opt/maven3 && \
        ## Remove platform specific files and dir
        rm -rf /opt/maven3/bin/mvn.cmd && \
        rm -rf /opt/maven3/bin/mvnDebug.cmd && \
        rm -rf /opt/maven3/lib/ext && \
        rm -rf /opt/maven3/lib/jansi-native/freebsd32 && \
        rm -rf /opt/maven3/lib/jansi-native/freebsd64 && \
        rm -rf /opt/maven3/lib/jansi-native/linux32 && \
        rm -rf /opt/maven3/lib/jansi-native/osx && \
        rm -rf /opt/maven3/lib/jansi-native/windows32 && \
        rm -rf /opt/maven3/lib/jansi-native/windows64 && \
        rm -rf /opt/maven3/lib/jansi-native/README.txt && \
        rm -rf /opt/maven3/README.txt && \
        echo "apache-maven-${MAVEN3_VERSION}" > /opt/maven3/release && \
    # Clear temp files
        apt clean && \
        rm -rf /var/cache/apt/archives && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /tmp/* && \
        rm -rf /var/tmp/* && \
    # Create entrypoint file
        echo '#!/bin/sh' >> /entry.sh && \
        echo 'exec "$@"' >> /entry.sh && \
        chmod 755 /entry.sh
# ----------------------------------------------------------------------------------------------------------------------------
ENV JAVA_HOME /opt/jdk11
ENV MAVEN_HOME /opt/maven3
ENV TASKS_HOME /tasks
ENV PATH $PATH:$TASKS_HOME:$JAVA_HOME/bin:$MAVEN_HOME/bin

ENV CI_LIBS "apt-transport-https, ca-certificates, software-properties-common, wget, curl, nano"
ENV CI_TOOLS "gnupg2, git, docker-ce-client, docker-compose, jdk11, maven 3"

WORKDIR /root
# ----------------------------------------------------------------------------------------------------------------------------
ENTRYPOINT ["/entry.sh"]
CMD ["bash"]
