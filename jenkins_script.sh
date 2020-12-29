#!/bin/sh -xe

# Needs:
# PD_JAIL=121Ramd64
# PD_JAIL_RELEASE=12.1-RELEASE
# PD_TREE=development
# PD_TREE_PATH=/home/guangyuan/freebsd-ports

if [ "${GIT_BRANCH}" = 'origin/main' ]; then
  exit 0
fi

# Clean up ports tree
cd ${PD_TREE_PATH}
git clean -df
git checkout -- .
git pull

# Environmental variables
cd ${WORKSPACE}/src
CHANGE_TITLE=$(git log --pretty=format:%s | head -n1)

# Get into Ports tree
cd ${PD_TREE_PATH}

# Bulk build
case ${GIT_BRANCH} in origin/bulk*)
  # Apply patch
  PATCH_NAME="$(echo ${GIT_BRANCH} | cut -d'/' -f2).diff"
  patch -p1 -u < ${WORKSPACE}/src/patches/${PATCH_NAME}

  # Build
  sudo poudriere bulk -f ${PD_TREE_PATH}/pkglist -j ${PD_JAIL} -p ${PD_TREE}
  exit 0
esac

# Apply patch
patch -p1 -u < ${WORKSPACE}/src/patches/${PATCH_NAME}

# in Jenkins, GIT_BRANCH=origin/devel/R-cran-covr
PORT_CAT=$(echo ${GIT_BRANCH} | awk -F '/' '{print $2}')
PORT_NAME=$(echo ${GIT_BRANCH} | awk -F '/' '{print $3}')
PORT_VER=$(echo ${CHANGE_TITLE} | awk -F ':' '{print $2}')
PATCH_NAME="${PORT_CAT}.${PORT_NAME}.${PORT_VER}.diff"

# Build
sudo poudriere testport -j ${PD_JAIL} -p ${PD_TREE} -o ${PORT_CAT}/${PORT_NAME}
