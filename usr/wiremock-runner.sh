#!/bin/bash -ex


install_utilities() {
    DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt install wget curl --yes
}


install_sauce_connect() {
    release="5.0.1"
    [[ $(uname -m) == "aarch64" ]] && arch="arm64" || arch="amd64"
    curl -L -o /tmp/sauce-connect.deb "https://saucelabs.com/downloads/sauce-connect/${release}/sauce-connect_${release}.linux_${arch}.deb"
    dpkg -i /tmp/sauce-connect.deb
}


check_wiremocks() {
    wireMockRc=0
    i=${WIREMOCK_PORT_START}
    until [[ $i -gt ${WIREMOCK_PORT_END} ]]
    do
        check_wiremock ${i}
        ((wireMockRc=wireMockRc+$?))
        ((i=i+1))
    done
    return ${wireMockRc}
}


check_wiremock() {
    wireMockPort=${1}
    hostName="test-runner.internal"
    tries=2
    printf '\nWaiting for WireMock-%s to start...\n' ${wireMockPort}
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=${tries} http://${hostName}:${wireMockPort}/__admin/mappings?limit=1
    wgetRc=$?
    [[ ${wgetRc} = 0 ]] && printf 'WireMock-%s is ready!\n' ${wireMockPort} || printf 'WireMock-%s is NOTOK!\n' ${wireMockPort}
    return ${wgetRc}
}


main() {
    sleep 5
    install_utilities
    install_sauce_connect
    check_wiremocks
    if [[ $? -ge 1 ]]; then
        printf '\nWireMock Services NOTOK...exiting\n'
        return 4
    fi
    printf '\nWireMock Services are OK...starting Sauce Connect!\n'
    export SAUCE_METADATA="runner=orchestrate,runID=${__SO_UUID}"
    /usr/bin/sc run
}


main