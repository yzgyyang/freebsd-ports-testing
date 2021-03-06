#!/bin/sh -xe

PORT_CAT=$(echo ${CIRRUS_BRANCH} | awk -F '/' '{print $1}')
PORT_NAME=$(echo ${CIRRUS_BRANCH} | awk -F '/' '{print $2}')
PORT_VER=$(echo ${CIRRUS_CHANGE_TITLE} | awk -F ':' '{print $2}')
PATCH_NAME="${PORT_CAT}.${PORT_NAME}.${PORT_VER}.diff"
PD_JAIL_RELEASE_A=$(echo ${PD_JAIL_RELEASE} | awk -F '.' '{print $1}')
PD_ABI="FreeBSD:${PD_JAIL_RELEASE_A}:${PD_ARCH}"

cd ${PD_TREE_PATH} && git apply ${CIRRUS_WORKING_DIR}/patches/${PATCH_NAME}

poudriere testport -j ${PD_JAIL} -p ${PD_TREE} -o ${CIRRUS_BRANCH}
