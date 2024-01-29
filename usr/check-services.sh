#!/bin/sh -x

logPath="/var/log"
mkdir -p ${logPath}

apk update && apk add curl bash wget && rm -rf /var/cache/apk/*
sleep 5

# check services
printf '\n Waiting for Sauce Connect to start...'
wget --retry-connrefused --retry-on-http-error=400,503 -t 0 http://localhost:8032/readiness
printf '\n\n\n Sauce Connect tunnel is ready!\n'

printf '\n Waiting for WireMock to start...'
wget --retry-connrefused --retry-on-http-error=400,503 -t 0 http://localhost:8080/__admin/mappings
printf '\n\n\n WireMock is ready!\n'

printf '\n Waiting for NGINX to start...'
wget --retry-connrefused --retry-on-http-error=400,503 -t 0 http://localhost:80
printf '\n\n\n NGINX is ready!\n'


# run main
cd ${logPath}
wget --output-document=service-sauce-connect-readiness.log http://localhost:8032/readiness
wget --output-document=service-nginx-index.log http://localhost:80
wget --output-document=service-wiremock-mappings.log http://localhost:8080/__admin/mappings

pwd         > ${logPath}/pwd.log    2>&1
env         > ${logPath}/env.log    2>&1
ls -la      > ${logPath}/ls.log     2>&1
getconf -a  > ${logPath}/gconf.log  2>&1
tree        > ${logPath}/tree.log   2>&1


# pauce for live test validation
printf '\n\n\nScript Pausing for 5 minutes!\n' 
printf 'Open Live Browser Session in Sauce Labs Dashboard.\n'
printf 'Select Tunnel Name: %s\n' ${SAUCE_TUNNEL_NAME}
printf 'Start Session and Browse WireMock and NGINX.\n'

sleep 240
printf '\n%s 60s left...!\n' ${0}
sleep 60

printf '\n%s script run complete!\n' ${0}
exit 0