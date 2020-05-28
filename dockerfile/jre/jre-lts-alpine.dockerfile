##############################################################################################################################
# The Alpine Linux base docker image with installed Zulu Community Open JRE 11                                               #
#                                                                                                                            #
# @author nedis                                                                                                              #
##############################################################################################################################
# Build:
# docker build -t rxmicro/jre:11.0.7-alpine -t rxmicro/jre:11-alpine -t rxmicro/jre:alpine -f jre-lts-alpine.dockerfile .
#
# Run:
# docker run -it --rm --name jre11-alpine rxmicro/jre:11-alpine
#
# Copy JRE:
# docker cp jre-alpine:/opt/jre11 ~/jre11-alpine
#
# Push:
# docker push rxmicro/jre:11.0.7-alpine
# docker push rxmicro/jre:11-alpine
# docker push rxmicro/jre:alpine
# ----------------------------------------------------------------------------------------------------------------------------
# Links:
# Alpine releases:      https://hub.docker.com/_/alpine?tab=tags
# Package managmenet:   https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
# BusyBox:              https://busybox.net/downloads/BusyBox.html
# Azul Commutiny:       https://www.azul.com/downloads/zulu-community/
#
# ----------------------------------------------------------------------------------------------------------------------------
# Versions:
# ----------------------------------------------------------------------------------------------------------------------------
ARG ALPINE_VERSION=3.11.5
ARG ZULU_JDK_VERSION=zulu11.39.15-ca-jdk11.0.7-linux_musl_x64
ARG AZUL_JDK_SHA_256_CHECKSUM=0de7ac5afede2ddeda399f10c9f9df83f91c9b60481ecf304aa5785ed50f36ce
# ----------------------------------------------------------------------------------------------------------------------------
FROM alpine:${ALPINE_VERSION}

ARG ZULU_JDK_VERSION
ARG AZUL_JDK_SHA_256_CHECKSUM
ARG ZULU_JDK_TAR_GZ=${ZULU_JDK_VERSION}.tar.gz
ARG ZULU_JDK_DOWNLOAD_LINK=https://cdn.azul.com/zulu/bin/${ZULU_JDK_TAR_GZ}
ARG JAVA_MODULES=java.base,jdk.unsupported,java.logging,java.net.http
# ----------------------------------------------------------------------------------------------------------------------------
RUN cd /tmp && \
    # Download, verify and unzip
    wget ${ZULU_JDK_DOWNLOAD_LINK} && \
    echo "$AZUL_JDK_SHA_256_CHECKSUM  $ZULU_JDK_TAR_GZ" | sha256sum -c - && \
    tar -xvzf ${ZULU_JDK_TAR_GZ} && \
    # Build JRE
    ${ZULU_JDK_VERSION}/bin/jlink --add-modules $JAVA_MODULES --compress=2 --no-header-files --no-man-pages --output /opt/jre11 && \
    cd /opt/jre11 && \
    # Remove temp dirs
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*
# ----------------------------------------------------------------------------------------------------------------------------
ENV JAVA_HOME /opt/jre11
ENV PATH $PATH:$JAVA_HOME/bin
