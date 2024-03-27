#!/bin/bash -ex


install_utilities() {
    DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt install wget curl --yes
}


install_sauce_connect() {
    release="5.0.1"
    [[ $(uname -m) == "aarch64" ]] && arch="arm64" || arch="amd64"
    curl -L -o /tmp/sauce-connect.deb https://saucelabs.com/downloads/sauce-connect/${release}/sauce-connect_${release}.linux_${arch}.deb
    dpkg -i /tmp/sauce-connect.deb
}


check_tunnel() {
    set -e 
    apiPort=${1}
    t=5
    printf '\n Waiting for Sauce Connect on API Port %s to start...' ${apiPort}
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=10 http://localhost:${apiPort}/readiness \
    && printf '\n\n\n Sauce Connect tunnel is ready!\n' || printf '\n\n\n Sauce Connect is NOTOK!\n'
}


main(){
    set -e
    install_utilities
    install_sauce_connect
    check_tunnel 8132
    check_tunnel 8232
    check_tunnel 8332
    check_tunnel 8432
    sleep 5
    export SAUCE_METADATA="runner=orchestrate,runID=${__SO_UUID}"
    /usr/bin/sc run
}


main