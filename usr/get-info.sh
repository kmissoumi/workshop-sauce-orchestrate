#!/bin/sh -x

pwd             > pwd.log   2>&1
env             > env.log   2>&1
ls -la          > ls.log    2>&1
java -version   > java.log  2>&1
npm --version   > npm.log   2>&1
tree            > tree1.log 2>&1
tree /usr/build > tree2.log 2>&1
tree /root      > tree3.log 2>&1
