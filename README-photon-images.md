```sh
# macos and linux subsystem for windows

# set env
export SAUCE_USERNAME=""            # string, sauce labs username
export SAUCE_ACCESS_KEY=""          # string, sauce labs access key
export SAUCE_REGION=""              # string, "us-west-1" or "eu-central-1"

# check env
which sc saucectl jq docker curl npm java && printf '\nBin check completed OK!\n' || printf '\nBin check NOTOK! Stop, install, and re-run.\n'
env|grep SAUCE

# run via localhost
npm install --prefix demo-webdriverio/webdriver/best-practices
npm run     --prefix demo-webdriverio/webdriver/best-practices test.saucelabs.v2

# run via docker image
docker run \
    --platform linux/amd64 --pull always \
    --env SAUCE_USERNAME=${SAUCE_USERNAME} \
    --env SAUCE_ACCESS_KEY=${SAUCE_ACCESS_KEY} \
    --env SAUCE_REGION=${SAUCE_REGION} \
    --env SAUCE_BUILD_TYPE="Docker" \
    docker.io/suncup/photon-js:latest \
    npm run --prefix demo-webdriverio/webdriver/best-practices test.saucelabs.v2

# run via hosted orchestration
# same docker image, same command, different execution location
#
saucectl run --config .sauce/config-wdio-webdriver-best-practices.yml
```

[![Build & Test Image for Webdriver Demo](https://github.com/kmissoumi/photon-images/actions/workflows/photon-build-image-js.yml/badge.svg)](https://github.com/kmissoumi/photon-images/actions/workflows/photon-build-image-js.yml)  
[![Build & Test Image for Java Demo](https://github.com/kmissoumi/photon-images/actions/workflows/photon-build-image-java.yml/badge.svg)](https://github.com/kmissoumi/photon-images/actions/workflows/photon-build-image-java.yml)  
[![Build & Test Image for Nightwatch Demo](https://github.com/kmissoumi/photon-images/actions/workflows/photon-build-image-nightwatch.yml/badge.svg)](https://github.com/kmissoumi/photon-images/actions/workflows/photon-build-image-nightwatch.yml)  
