#!/usr/bin/env bash
##############################################################################################################################
# The bash script for installing the commit-msg hook for UN*X                                                                #
#                                                                                                                            #
# @author nedis                                                                                                              #
#                                                                                                                            #
##############################################################################################################################
# Install instructions:                                                                                                      #
#                                                                                                                            #
# cd cd /path/to/the/git/local/repository                                                                                    #
# COMMIT_MSG_SETUP_SCRIPT_LOCATION=https://raw.githubusercontent.com/rxmicro/dev/master/git/commit-msg-guidelines/setup.sh   #
# rm -rf /tmp/setup && wget $COMMIT_MSG_SETUP_SCRIPT_LOCATION -O /tmp/setup && chmod 755 /tmp/setup && /tmp/setup            #
#                                                                                                                            #
##############################################################################################################################
HOOK_STORAGE_ROOT_URL=https://raw.githubusercontent.com/rxmicro/dev/master/git/commit-msg-guidelines
# ----------------------------------------------------------------------------------------------------------------------------
HOOK_SCRIPT_NAME=CommitMsg
VERBS_FILE_NAME=.verbs
DOWNLOAD_HOOK_SCRIPT_URL=${HOOK_STORAGE_ROOT_URL}/src/main/java/${HOOK_SCRIPT_NAME}.java
DOWNLOAD_VERBS_FILE_URL=${HOOK_STORAGE_ROOT_URL}/${VERBS_FILE_NAME}
# ----------------------------------------------------------------------------------------------------------------------------
HOOKS_DIR=.git/hooks
HOOK_NAME=commit-msg
# ----------------------------------------------------------------------------------------------------------------------------
# Exit when any command fails
set -eu -o pipefail
# ----------------------------------------------------------------------------------------------------------------------------
# Verify that current dir is git repository:
if [[ ! -d "$HOOKS_DIR" ]]; then
  echo "'${HOOKS_DIR}' not found. Is it a git repository?" >&2
  exit 51
fi
# ----------------------------------------------------------------------------------------------------------------------------
# Verify that commit-msg is not installed:
HOOK_PATH=${HOOKS_DIR}/${HOOK_NAME}
if [[ -f "$HOOK_PATH" ]]; then
  echo "'${HOOK_PATH}' already exist. Skip installation." >&2
  exit 52
fi
# ----------------------------------------------------------------------------------------------------------------------------
# Verify that javac is available:
set +e
JAVAC_CMD=`which javac`
set -e
if [[ ! -x "$JAVAC_CMD" ]]; then
  echo "Add \"javac\" to the PATH variable, before using this script!" >&2
  exit 53
fi
# ----------------------------------------------------------------------------------------------------------------------------
# Verify that java is available:
set +e
JAVA_CMD=`which java`
set -e
if [[ ! -x "$JAVA_CMD" ]]; then
  echo "Add \"java\" to the PATH variable, before using this script!" >&2
  exit 54
fi
# ----------------------------------------------------------------------------------------------------------------------------
# Download CommitMsg.java
wget -O ${HOOKS_DIR}/${HOOK_SCRIPT_NAME}.java ${DOWNLOAD_HOOK_SCRIPT_URL}
cd ${HOOKS_DIR}
# Compile CommitMsg.java
javac ${HOOK_SCRIPT_NAME}.java
# Create commit-msg file
echo "java -cp \"${HOOKS_DIR}\" ${HOOK_SCRIPT_NAME} \$1" > commit-msg
# Make commit-msg executable
chmod 755 commit-msg
# ----------------------------------------------------------------------------------------------------------------------------
# Download .verbs if not found
VERBS_FILE_PATH=${HOME}/${VERBS_FILE_NAME}
if [[ ! -f "$VERBS_FILE_PATH" ]]; then
  wget ${DOWNLOAD_VERBS_FILE_URL} -O "${VERBS_FILE_PATH}"
  echo "Init version of ${VERBS_FILE_NAME} installed successful."
fi
# ----------------------------------------------------------------------------------------------------------------------------
# Show success message
echo "'${HOOK_NAME}' installed successful."
