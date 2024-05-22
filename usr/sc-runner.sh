#!/bin/bash -ex


install_utilities() {
    DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt install wget curl --yes
}


install_sauce_connect() {
    #https://saucelabs.com/rest/v1/public/tunnels/info/versions
    [[ -z ${SAUCE_CONNECT_RELEASE} ]] && scRelease="5.1.0" || scRelease=${SAUCE_CONNECT_RELEASE}
    [[ $(uname -m) == "aarch64" ]] && arch="arm64" || arch="amd64"
    curl -L -o /tmp/sauce-connect.deb "https://saucelabs.com/downloads/sauce-connect/${scRelease}/sauce-connect_${scRelease}.linux_${arch}.deb"
    dpkg -i /tmp/sauce-connect.deb
}


check_tunnels() {
    proxyPartyRc=0
    apiPort=8032
    apiPortEnd=$(( apiPort + NO_PROXY_PARTY_INSTANCES*100 ))
    until [[ ${apiPort} -gt ${apiPortEnd} ]]
    do
        check_tunnel ${apiPort}
        ((proxyPartyRc=proxyPartyRc+$?))
        ((apiPort=apiPort+100))
    done
    return ${proxyPartyRc}
}


check_tunnel() {
    apiPort=${1}
    hostName="test-runner.internal"
    tries=4
    printf '\nWaiting for Sauce Connect on API Port %s to start...\n' ${apiPort}
    wget --retry-connrefused --retry-on-http-error=400,503 --tries=${tries} http://${hostName}:${apiPort}/readiness
    wgetRc=$?
    [[ ${wgetRc} = 0 ]] && printf 'Sauce Connect tunnel on API Port %s is ready!\n' ${apiPort} || printf 'Sauce Connect tunnel on API Port %s is NOTOK!\n' ${apiPort} 
    return ${wgetRc}
}


main(){
    sleep 5
    install_utilities
    install_sauce_connect
    if [[ $? -ge 1 ]]; then
        printf '\nSauce Connect Install NOTOK...exiting\n'
        return 4
    fi
    
    check_tunnels
    if [[ $? -ge 1 ]]; then
        printf '\nProxy Party Tunnels NOTOK...exiting\n'
        return 4
    fi
    
    printf '\nProxy Party Tunnels are OK...starting Sauce Connect!\n'
    export SAUCE_METADATA="runner=orchestrate,runID=${__SO_UUID}"
    /usr/bin/sc run
}


main