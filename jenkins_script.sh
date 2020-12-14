#!/bin/sh -xe

# Needs:
# PD_JAIL=121Ramd64
# PD_JAIL_RELEASE=12.1-RELEASE
# PD_TREE=development
# PD_TREE_PATH=/home/guangyuan/freebsd-ports

if [ "${GIT_BRANCH}" = 'origin/main' ]; then
exit 0
fi

# Set env
cd ${WORKSPACE}/src

# in Jenkins, GIT_BRANCH=origin/devel/R-cran-covr
PORT_CAT=$(echo ${GIT_BRANCH} | awk -F '/' '{print $2}')
PORT_NAME=$(echo ${GIT_BRANCH} | awk -F '/' '{print $3}')
CHANGE_TITLE=$(git log --pretty=format:%s | head -n1)
PORT_VER=$(echo ${CHANGE_TITLE} | awk -F ':' '{print $2}')
PATCH_NAME="${PORT_CAT}.${PORT_NAME}.${PORT_VER}.diff"
PD_JAIL_RELEASE_A=$(echo ${PD_JAIL_RELEASE} | awk -F '.' '{print $1}')

env

# Clean up ports tree
cd ${PD_TREE_PATH}
git clean -df
git checkout -- .
git checkout master
git clean -df
git checkout -- .
git pull upstream master

# Apply patch
patch < ${WORKSPACE}/src/patches/${PATCH_NAME}

# Build
sudo poudriere testport -j ${PD_JAIL} -p ${PD_TREE} -o ${PORT_CAT}/${PORT_NAME}
