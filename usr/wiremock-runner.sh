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


check_wiremocks() {
    i=${WIREMOCK_PORT_START}
    until [ $i -gt ${WIREMOCK_PORT_END} ]
    do
        check_wiremock ${i}
        ((i=i+1))
    done
}


check_wiremock() {
    set -e 
    wireMockPort=${1}
    t=5
    printf '\n Waiting for WireMock-%s to start...\n' ${wireMockPort}
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=${t} http://test-runner.internal:${wireMockPort}/__admin/mappings \
        && printf 'WireMock-%s is ready!\n' ${wireMockPort} || printf 'WireMock-%s is NOTOK!\n' ${wireMockPort}
}


main(){
    set -e
    sleep 5
    install_utilities
    install_sauce_connect
    check_wiremocks
    export SAUCE_METADATA="runner=orchestrate,runID=${__SO_UUID}"
    /usr/bin/sc run
}


main