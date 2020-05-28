##############################################################################################################################
# The Alpine Linux base docker image with installed glibc library                                                            #
#                                                                                                                            #
# @author nedis                                                                                                              #
##############################################################################################################################
# Build:
# docker build -t rxmicro/alpine-glibc:2.31 -t rxmicro/alpine-glibc -f alpine-glibc.dockerfile .
#
# Push:
# docker push rxmicro/alpine-glibc:2.31
# docker push rxmicro/alpine-glibc
# ----------------------------------------------------------------------------------------------------------------------------
# Links:
# Alpine releases:      https://hub.docker.com/_/alpine?tab=tags
# Package managmenet:   https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
# BusyBox:              https://busybox.net/downloads/BusyBox.html
# glibc releases:       https://github.com/sgerrand/alpine-pkg-glibc/releases
#
# ----------------------------------------------------------------------------------------------------------------------------
# Versions:
# ----------------------------------------------------------------------------------------------------------------------------
ARG ALPINE_VERSION=3.11.5
ARG GLIBC_APK_VERSION=2.31-r0
# ----------------------------------------------------------------------------------------------------------------------------
FROM alpine:${ALPINE_VERSION}

ARG GLIBC_APK_VERSION
ARG GLIBC_APK=glibc-${GLIBC_APK_VERSION}.apk
ARG GLIBC_APK_DOWNLOAD_LINK=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_APK_VERSION}/${GLIBC_APK}

# ----------------------------------------------------------------------------------------------------------------------------
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    cd /tmp && \
    wget ${GLIBC_APK_DOWNLOAD_LINK} && \
    apk add --no-cache ${GLIBC_APK} && \
    rm /etc/apk/keys/sgerrand.rsa.pub  && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

ENV LD_LIBRARY_PATH=/lib
