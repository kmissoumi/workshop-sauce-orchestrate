#!/bin/sh -x

logPath="/var/log"

pwd             > ${logPath}/pwd.log    2>&1
env             > ${logPath}/env.log    2>&1
getconf -a      > ${logPath}/gconf.log  2>&1
ls -la          > ${logPath}/ls.log     2>&1
java -version   > ${logPath}/java.log   2>&1
npm --version   > ${logPath}/npm.log    2>&1
node --version  > ${logPath}/node.log   2>&1

tree /          > ${logPath}/tree_slash.log 2>&1
tree /usr       > ${logPath}/tree_usr.log   2>&1
tree /usr/build > ${logPath}/tree_build.log 2>&1
tree /root      > ${logPath}/tree_root.log  2>&1
tree /var/log   > ${logPath}/tree_var.log   2>&1

which sh bash node npm tree pwd env ls > which.log 2>&1

exit 0