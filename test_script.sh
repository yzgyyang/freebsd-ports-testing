#!/bin/sh -e

PORT_CAT=$(echo ${CIRRUS_BRANCH} | awk -F '/' '{print $1}')
PORT_NAME=$(echo ${CIRRUS_BRANCH} | awk -F '/' '{print $2}')
PORT_VER=$(echo ${CIRRUS_CHANGE_TITLE} | awk -F ':' '{print $2}')
PATCH_NAME="${PORT_CAT}.${PORT_NAME}.${PORT_VER}.diff"
cd ${PD_TREE_PATH} && git apply ${CIRRUS_WORKING_DIR}/patches/${PATCH_NAME}
poudriere testport -j ${PD_JAIL} -p ${PD_TREE} -o ${CIRRUS_BRANCH}
