#!/bin/sh -xe

pkg update -f
pkg install -y git poudriere
git clone --depth 1 --single-branch -b master https://github.com/freebsd/freebsd-ports ${PD_TREE_PATH}

echo "NO_ZFS=yes" >> /usr/local/etc/poudriere.conf
sed -i.bak -e 's,FREEBSD_HOST=_PROTO_://_CHANGE_THIS_,FREEBSD_HOST=https://download.FreeBSD.org,' /usr/local/etc/poudriere.conf
mkdir -p /usr/local/poudriere

poudriere jail -c -j ${PD_JAIL} -v ${PD_JAIL_RELEASE} -a ${PD_ARCH}
poudriere ports -c -m null -M ${PD_TREE_PATH} -p ${PD_TREE}
