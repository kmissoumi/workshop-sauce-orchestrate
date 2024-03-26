#!/bin/sh -x

logPath="/var/log"
mkdir -p ${logPath}

apk update && apk add curl bash wget && rm -rf /var/cache/apk/*
sleep 5

NGIX_PORT_01=80
NGIX_PORT_02=8888
WIREMOCK_PORT=8080


check_services() {

    printf '\n Waiting for WireMock to start...'
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=10 http://localhost:${WIREMOCK_PORT}/__admin/mappings \
    && printf '\n\n\n WireMock is ready!\n' || printf '\n\n\n WireMock is NOTOK!\n'

    printf '\n Waiting for Sauce Connect to start...'
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=10 http://localhost:8032/readiness \
    && printf '\n\n\n Sauce Connect tunnel is ready!\n' || printf '\n\n\n Sauce Connect is NOTOK!\n'

    printf '\n Waiting for NGINX to start...'
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=10 http://localhost:${NGINX_PORT_01} \
    && printf '\n\n\n NGINX is ready!\n' || printf '\n\n\n NGINX is NOTOK!\n'

    printf '\n Waiting for NGINX No. 2 to start...'
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=10 http://localhost:${NGINX_PORT_02} \
    && printf '\n\n\n NGINX is ready!\n' || printf '\n\n\n NGINX is NOTOK!\n'
}


get_index () {
    cd ${logPath}
    wget --output-document=service-sauce-connect-readiness.log http://localhost:8032/readiness
    wget --output-document=service-nginx-index.log http://localhost:${NGIX_PORT_01}
    wget --output-document=service-nginx-index.log http://localhost:${NGIX_PORT_01}
    wget --output-document=service-wiremock-mappings.log http://localhost:${WIREMOCK_PORT}/__admin/mappings
}


#check_services
#get_index

printf '\n Waiting for Sauce Connect to start...'
wget --retry-connrefused --retry-on-http-error=400,503 --tries=5 http://localhost:8032/readiness \
&& printf '\n\n\n Sauce Connect tunnel is ready!\n' || printf '\n\n\n Sauce Connect is NOTOK!\n'

pwd         > ${logPath}/pwd.log    2>&1
env         > ${logPath}/env.log    2>&1
ls -la      > ${logPath}/ls.log     2>&1
getconf -a  > ${logPath}/gconf.log  2>&1
tree        > ${logPath}/tree.log   2>&1


# pauce for live test validation
live_check() {
    WAIT_MINUTES=5
    WAIT_SECONDS=$((${WAIT_MINUTES} * 60))
    printf '\n\n\nScript Pausing for %s minutes!\n' ${WAIT_MINUTES}
    printf 'Open Live Browser Session in Sauce Labs Dashboard.\n'
    printf 'Select Tunnel Name: %s\n' ${SAUCE_TUNNEL_NAME}
    printf 'Start Session and Browse WireMock and NGINX.\n'

    sleep $((${WAIT_SECONDS} - 60))
    printf '\n%s 60s left...!\n' ${0}
    sleep 60
}


live_check
printf '\n%s script run complete!\n' ${0}
exit 0