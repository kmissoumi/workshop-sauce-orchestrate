answer-key.md





### module 1.1

```
11:02:00 ERR Suite finished. error="runner start failed (400): {\"code\":\"ERR_VALIDATION_FAILED\",\"message\":\"env.3.value: property \\\"value\\\" is missing\"}\n" passed=false runID= suite=photon-java
11:11:28 ERR Suite finished. error="runner start failed (400): {\"code\":\"ERR_VALIDATION_FAILED\",\"message\":\"env.1.value: property \\\"value\\\" is missing\"}\n" passed=false runID= suite=photon-java
```
An environment variable is missing. The env.<n> changes, so it's not the order in the file, but the order as interuprutted by saucectl.
You can enter a value, comment out the key in the file, or pass the value via `--env`.

What could this mean later during the execution of the test?


1.3

export runID="1b60d720e5c24c98bfca2bfb413fd16b"
saucectl 

BUILD_ID=$(date +"%Y-%m-%d_%H%M%S") saucectl run --config config-newman.yml

# set the runID and pull the console output and uploaded artifacts 
runID=""
saucectl imagerunner logs ${runID} --region ${SAUCE_REGION}
saucectl imagerunner artifacts download ${runID} "*" --target-dir artifacts/${runID} --out json --region ${SAUCE_REGION}
---





---


module 2


```
11:59:33 ERR Suite finished. error="suite \"photon-js-webdriverio\" failed: Test runner terminated with code 254" passed=false runID=c527ad5af018439ca3c741ced1789400 suite=photon-js-webdriverio
11:59:41 INF Suites in progress: 0

### CONSOLE OUT "photon-js-webdriverio" ###
npm ERR! code ENOENT
npm ERR! syscall open
npm ERR! path /usr/build/demo-webdriverio/package.json
npm ERR! errno -2
npm ERR! enoent ENOENT: no such file or directory, open '/usr/build/demo-webdriverio/package.json'
npm ERR! enoent This is related to npm not being able to find a file.
npm ERR! enoent 

npm ERR! A complete log of this run can be found in: /root/.npm/_logs/2023-07-24T09_59_21_054Z-debug-0.log

### CONSOLE END ###

       Name                                Duration    Status    Attempts  
───────────────────────────────────────────────────────────────────────────
  ✖    photon-js-webdriverio                    32s    Failed           1  
───────────────────────────────────────────────────────────────────────────
  ✖    1 of 1 suites have failed (100%)         43s                            

```


---

```
saucectl imagerunner artifacts download ${runID} "*" --target-dir artifacts/${runID} --out json --region ${SAUCE_REGION}

Error: failed to fetch artifacts: request failed; unexpected response code: '404', msg: '<?xml version='1.0' encoding='UTF-8'?><Error><Code>NoSuchKey</Code><Message>The specified key does not exist.</Message><Details>No such object: sauce-the-hostedjobs-uploads-pzdc/testrunners/1b60d720e5c24c98bfca2bfb413fd16b/artifacts.zip</Details></Error>'


# no custom artifacts were found
```


https://webhook.site/#!/611ea166-d1ea-4705-b433-f368281a72af


https://webhook.site/611ea166-d1ea-4705-b433-f368281a72af



