##############################################################################################################################
# The Alpine Linux base docker image with installed curl and busybox-extras components                                       #
#                                                                                                                            #
# @author nedis                                                                                                              #
##############################################################################################################################
# Build:
# docker build -t rxmicro/terminal -f alpine-terminal.dockerfile .
#
# Push:
# docker push rxmicro/terminal
# ----------------------------------------------------------------------------------------------------------------------------
# Links:
# Alpine releases:      https://hub.docker.com/_/alpine?tab=tags
# Package managmenet:   https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
# BusyBox:              https://busybox.net/downloads/BusyBox.html
#
# ----------------------------------------------------------------------------------------------------------------------------
# Versions:
# ----------------------------------------------------------------------------------------------------------------------------
ARG ALPINE_VERSION=3.11.5
# ----------------------------------------------------------------------------------------------------------------------------
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache busybox-extras && \
    apk add --no-cache curl && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*
