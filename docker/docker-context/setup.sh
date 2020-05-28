#!/usr/bin/env bash
##############################################################################################################################
# The bash script for displaying current docker context for UN*X                                                             #
#                                                                                                                            #
# @author nedis                                                                                                              #
#                                                                                                                            #
##############################################################################################################################
# Install instructions:                                                                                                      #
#                                                                                                                            #
# DOCKER_CONTEXT_SETUP_SCRIPT_LOCATION=https://raw.githubusercontent.com/rxmicro/dev/master/docker/docker-context/setup.sh   #
# sudo wget $DOCKER_CONTEXT_SETUP_SCRIPT_LOCATION -o /usr/local/bin/docker-context && \                                      #
#           sudo chmod 755 /usr/local/bin/docker-context                                                                     #
#                                                                                                                            #
##############################################################################################################################
# Usage instructions:                                                                                                        #
#                                                                                                                            #
# cd /path/to/the/project/dir                                                                                                #
# docker-context                                                                                                             #
#                                                                                                                            #
# To configure docker context use `.dockerignore` file.                                                                      #
# Read more: https://docs.docker.com/engine/reference/builder/#dockerignore-file                                             #
##############################################################################################################################
# Exit when any command fails
set -eu -o pipefail
# ----------------------------------------------------------------------------------------------------------------------------
# Create docker-context.dockerfile
{
    echo "FROM busybox",
    echo "RUN mkdir /docker-context",
    echo "COPY . /docker-context"
} > docker-context.dockerfile
# ----------------------------------------------------------------------------------------------------------------------------
# Build temp image context
docker build -q -t docker-context -f docker-context.dockerfile .
# ----------------------------------------------------------------------------------------------------------------------------
# Show docker context
RUN_ARGS="${RUN_ARGS}echo '----------------------------------------------------------------------------';"
RUN_ARGS="${RUN_ARGS}echo '------------------------------ DOCKER CONTEXT: -----------------------------';"
RUN_ARGS="${RUN_ARGS}echo '----------------------------------------------------------------------------';"

## Find all files at `/docker-context` directory:
RUN_ARGS="${RUN_ARGS}find /docker-context | "
## Remove /docker-context refix:
RUN_ARGS="${RUN_ARGS}sed 's/\/docker-context\///g' | sed 's/\/docker-context//g' | "
## Exclude docker-context.dockerfile from results:
RUN_ARGS="${RUN_ARGS}sed 's/docker-context.dockerfile//g' | "
## Remove empty results:
RUN_ARGS="${RUN_ARGS}sed -r '/^\s*$/d';"

RUN_ARGS="${RUN_ARGS}echo '----------------------------------------------------------------------------';"
RUN_ARGS="${RUN_ARGS}echo '-------------------------------- END CONTEXT -------------------------------';"
RUN_ARGS="${RUN_ARGS}echo '----------------------------------------------------------------------------'"

docker run --rm -it docker-context /bin/sh -c "${RUN_ARGS}"
# ----------------------------------------------------------------------------------------------------------------------------
# Remove docker image and file
docker rmi -f docker-context
rm -f docker-context.dockerfile
