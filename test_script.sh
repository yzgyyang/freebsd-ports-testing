#!/bin/sh -e

PORT_CAT=$(echo ${CIRRUS_BRANCH} | awk -F '/' '{print $1}')
PORT_NAME=$(echo ${CIRRUS_BRANCH} | awk -F '/' '{print $2}')
PORT_VER=$(echo ${CIRRUS_CHANGE_TITLE} | awk -F ':' '{print $2}')
PATCH_NAME="${PORT_CAT}.${PORT_NAME}.${PORT_VER}.diff"

cd ${PD_TREE_PATH} && git apply ${CIRRUS_WORKING_DIR}/patches/${PATCH_NAME}

# obtained from: https://github.com/freebsd/freebsd-ports-libreoffice/blob/8a09dffcc6a1502987ae054e43ac6c61c806d267/porttest.sh
poudriere bulk -t -j ${PD_JAIL} -p ${PD_TREE} net/nc
cd ${PD_TREE_PATH}/${CIRRUS_BRANCH}
pkg fetch -y -o pkgs `make missing-packages`
rm -rf /usr/local/poudriere/data/packages/jail-default/.latest/All
mv pkgs/All /usr/local/poudriere/data/packages/jail-default/.latest/
rm -rf pkgs

poudriere testport -j ${PD_JAIL} -p ${PD_TREE} -o ${CIRRUS_BRANCH}
