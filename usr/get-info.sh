#!/bin/sh -x

logPath="/var/log"

pwd             > ${logPath}/pwd.log    2>&1
env             > ${logPath}/env.log    2>&1
getconf -a      > ${logPath}/gconf.log  2>&1
ls -la          > ${logPath}/ls.log     2>&1

java -version   > ${logPath}/java.log   2>&1
npm --version   > ${logPath}/npm.log    2>&1
node --version  > ${logPath}/node.log   2>&1

which sh bash node npm tree pwd env ls > which.log 2>&1

rm -fr /usr/build/demo-webdriverio/webdriver/best-practices/node_modules
tree /usr/build > ${logPath}/tree.log   2>&1

printf '\n%s script run complete!\n' ${0}

exit 0