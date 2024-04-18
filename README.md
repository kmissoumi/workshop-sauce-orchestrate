# Sauce Orchestrate Workshop

This workshop provides practical exercises and example workflows for Sauce Orchestrate.


- Before starting. <!-- use homebrew -->
  - [Install Visual Code](https://code.visualstudio.com/docs/setup/setup-overview). 
  - Run this command  
  `docker image pull --platform linux/amd64 suncup/photon-js:latest`
  - [Install the latest release of `saucectl`](https://docs.saucelabs.com/dev/cli/saucectl/#installing-saucectl).
- During the workshop.
  - Explain your answers.  
  - Describe your thought process.

 
---

### Module 1


#### 1.1 Inspect
- Inspect the `saucectl` configuration file listed below.  
  [`.sauce/config-module-01.yml`](.sauce/config-module-01.yml)
  - What environment variables does it expect?
    - Make sure you have all the environment variables specified set.
  <!-- two ways to fail, a blank env value or a local $env that is not set SAUCE_REGION is not common -->
  <!-- the error message is vague so it is possible to fix the NASA_API_KEY issue and still have the SAUCE_REGION being unset cause an error you can `env|grep SAUCE` -->
  <!--
  ways to proceed
  1- remove or comment out
  2- enter a string or environment variable 
  
  you can also pass environment variables via run-time parameter
  e.g. saucectl run  --region ${SAUCE_REGION} --env NASA_API_KEY=5f95f9099fed4797bc26bd3cbb5097c9
  -->

  <!-- note you can also pass environment variables to the Orchestrate container via the env parameter, but this doesn't overlay on top of the configuration file
  so if you needed to pass an environment variable to the container and preferred to do it via parameter then you shouldn't have the env key for that variable in the configuration file
  this needs to be re-verified, we were running different versions of saucectl -->
  - What image does it use?
  - What is the [`resourceProfile`](https://docs.saucelabs.com/orchestrate/saucectl-configuration/#resourceprofile) key?
    - Hover over this key in the configuration file.
      - Did the schema validation overlay pop up?
  <!-- if not, in the left sidebar of Visual Studio Code, select the Tetris blocks and search for yaml
  install and enable the YAML Language Support extension  -->

    - Did you see any other configuration keys that might be useful?


#### 1.2 Run
- Run the `saucectl` command below. 
  - Describe what happened.
  - If successful, what did it do?
  - If unsuccessful, what does the error message say?
    - What does that mean?
    - How do you fix it?
  - What is a runID?


```sh
saucectl run --region ${SAUCE_REGION} --config .sauce/config-module-01.yml
```

---


### Module 2

#### 2.1a Inspect

- Inspect the `saucectl` configuration file listed below.  
  [`.sauce/config-module-02-01.yml`](.sauce/config-module-02-01.yml)  
  - Describe what it does.  


#### 2.1b Run
- Run the `saucectl` command below.
  - Describe what happened.
  - If successful, what did it do?
  - If unsuccessful, what does the error message say?
    - What does that mean?
    - How do you fix it?
    - What is the `runID`?
      - Write it down here.


```sh
saucectl run --region ${SAUCE_REGION} --config .sauce/config-module-02-01.yml
```


#### 2.2 Artifacts 
- Collect the log from the container.
  - Update the configuration file to download the error log.
  - Read about the configuration key named [artifacts](https://docs.saucelabs.com/orchestrate/saucectl-configuration/#artifacts).
  - Make a copy of the existing configuration and add the needed key to save a custom artifact.
    - We want to collect the error log that was referenced in the console output.

> This same configuration can be used to download custom reports or test artifacts that are written to the container.

```sh
saucectl run --region ${SAUCE_REGION}--config .sauce/config-module-02-02.yml
```

#### 2.3 Download
- Re-run with the new configuration.
  - Where is the file?
    - Copy the runID from the last run.
    - Export the runID.
  `export runID=`
    - Run the command listed below and then open the log file.
    <!-- copy the runID from the previous runner output, type export and then double click the runID in the terminal and do a copy/paste, less typing here, it should be fast -->  
  

```sh
saucectl imagerunner artifacts download ${runID} "*" --target-dir artifacts/runID-${runID}
```

#### 2.4 Logs
- What does the log from the container tell us?
  - Is this different than what the log from `saucectl` told us?
  - Pull the console output for this run from `saucectl`.
    - Confirm the answer needed was not already provided.
      <!-- at the previous step, did enter your runID directly or did you export it? -->

```sh
saucectl imagerunner logs ${runID} 
```


#### 2.5 Triage
- Where is the issue with the test?
  - How can we triage this issue further?
  - Can you collect all the available paths from the image? 
  - Create a new configuration file.
    - This time change the entry point to run the command listed below.  
`env`

```sh
saucectl run --region ${SAUCE_REGION} --config .sauce/config-module-02-05-01.yml
```

  - Try the command below next.  
    - Run this new configuration.
    - What output do you collect?
    - What does this tell you?
    - Have you confirmed what the issue is?
    - Do you now think the issue is related to something else?  
`ls -la demo-webdriverio`

```sh
saucectl run --region ${SAUCE_REGION} --config .sauce/config-module-02-05-02.yml
```

  - What if the output was truncated? <!-- it isn't, probably, I dunno -->
  - What about running a script with multiple commands? <!-- this is just an example of what is possible. it is useful to understand all the other bits -->
    - Update the configuration to send the output to a log.
    - Update the configuration to automatically download the log.
  


```sh
saucectl run --region ${SAUCE_REGION} --config .sauce/config-module-02-05-03.yml
```

  - What did this configuration file do?
    - Did we update the image? <!-- no, we don't have access to the image -->
    - Will the script be there if I run a different configuration? <!-- only if you include the files key as listed -->
    - Where are the logs generated by this script downloaded? <!-- that is controlled by the artifacts key -->
    - Does it matter where I place the artifacts key in the runner configuration? <!-- yes, if it is a child of a suite it defines which artifacts to save from the container, if at the top level of the runner configuration it is to control when to download the artifacts -->
    - The artifacts key is in the configuration file, but where the are job assets? e.g. video, console.log, etc.
        <!-- The runner configuration only manages the Sauce Orchestrate container run, which is represented by the provided runID.
        If there is an error and no runID is returned, then the failure happened early in the process. -->
        

> Note: saucectl can download job artifacts using the [_artifacts download_ command](https://docs.saucelabs.com/dev/cli/saucectl/artifacts/download/)


---


### Module 3

Up to this point...
- We have not used Docker.
- We have not built an image.  
- We have not looked at a DOCKER file.
- We have launched containers on Sauce Orchestrate.

Let's do the same investigation on a local container.
This provides us with an interactive session and will save a lot of time.
What if you don't have access to the image?
<!-- likely this will be the case and that is OK, the practice here will help you guide the person with access to the image -->
<!-- to help them once; provide the knowledge to directly troubleshoot future issues without your assistance -->


Keep everything as close as possible to the original configuration.  
Use the same variables passed in the `saucectl` configuration file.


#### 3.1 Interactive Session on Local Container


- Run the command below.
  
```sh
# use this image
export imageName='suncup/photon-js:latest'

# start a shell
docker run -it \
    --platform linux/amd64 \
    --env SAUCE_USERNAME=${SAUCE_USERNAME} \
    --env SAUCE_ACCESS_KEY=${SAUCE_ACCESS_KEY} \
    --env SAUCE_BUILD_TYPE="Docker Local Dev" \
    ${imageName} \
    sh
```

- Where are you?
  <!-- the container -->
- What can you fix?
  <!-- the entrypoint in the runner configuration
  the container is ephemeral
  and the image is immutable -->
- What is the `platform` parameter and why is it set to `linux/amd64`?
  - Docker images can be built for [different architectures and operating systems](https://docs.docker.com/build/building/multi-platform/).
  - Try the commands below.  
  `uname -m`  
  `uname -o`
    - What machine architecture are you using?
      - `x86_64` is the same `amd64`.
      - `arm64` is different.
    - What operating system are you using?


> Sauce Orchestrate supports images built for the `linux/amd64` platform.

<!--
image format follows <registry>/<org>/<image>:<tag> 
suncup/photon-js:latest is the same as docker.io/suncup/photon-js:latest
quay.io/saucelabs/piestry:latest
-->

#### 3.2 Working Command on Local Container

- Go through all the steps from Module 2 in this interactive session.
  - Is the [`get-info.sh`](usr/get-info.sh) script there?
  <!-- no it is not, the runner configuration overlayed the file in that specific container. the file does not exist on the image -->
  - What did you find?
  - Are you able to run the test from the base directory?
  <!-- you will need to run the command from the directory you start in -->
  <!-- the entrypoint in .sauce/config-module-03-01.yml is the correct command you need -->



#### 3.3 Validate the Entrypoint on a Local Container

- Get the test to run directly from the container.
  - What _should_ the entrypoint be? 
  <!--
  you can modify the docker run command and validate that it is the proper entrypoint
  we now know this entrypoint is valid for this specific image
  -->

  <!--
  the image tag we are using is `latest`, what does that mean?
  discussion for another module on image maintenance and building
  -->


#### 3.4 Validate the Entrypoint on an Orchestrate Container

- Fix the configuration and re-run via `saucectl`.

```sh
saucectl run --region ${SAUCE_REGION} --config .sauce/config-module-03-01.yml
```

#### 3.5 Module Recap

- What is the one thing needed to run these commands?
  <!-- access to the image -->
- What are you able to fix, change, or update?
  <!--
  runner configuration, i.e everything that is _NOT_ the image
    save artifacts from the orchestrate container
    add files to the orchestrate container  
  -->



### Module 4 Orchestrate+ Test Suite and Complete Test Environment Bundle


This module provides example configuration for a test suite with sidecar containers.  
  - These sidecars are defined in the suite's services section.  
  - All the containers can be reached via `localhost:port`.  
  - This example also shows how to stream the console logs.  

Inspect the `saucectl` configuration file listed below.  
  [`.sauce/config-module-04-01.yml`](.sauce/config-module-04-01.yml)  
  - What services are defined in the configuration?  
  - What does the Sauce Connect tunnel provide access to in this example?  
  - How are dependencies validated before the test suite starts?  


#### 4.1 Orchestrate+ Entire App & Sauce Connect

```sh
# saucectl support for live logs requires version 0.171.0 or later
saucectl --version

# export environment variables
env |grep SAUCE
#export SAUCE_REGION=
#export SAUCE_USERNAME=
#export SAUCE_ACCESS_KEY=
#export SAUCE_TUNNEL_NAME=


# run multi-service orchestrate example
saucectl run --live-logs --region ${SAUCE_REGION} --config .sauce/config-module-04-01.yml

# main suite will pause
#   launch a live browser session with tunnel
#       validate services are running as expected
#           open page http://localhost:80
#           open page http://localhost:8080/__admin/mappings

# allow suite to complete
#   check artifacts directory for logs 
```


#### 4.2a Orchestrate+ Standalone Services & Sauce Connect


```sh
# export environment variables
env |grep SAUCE
#export SAUCE_REGION=
#export SAUCE_USERNAME=
#export SAUCE_ACCESS_KEY=

# tunnel name must be unique, adding the value to file to reference in 2nd shell
export SAUCE_TUNNEL_NAME="wiremock-net-$(uuidgen)" && printf '%s' ${SAUCE_TUNNEL_NAME} > my_tunnel_name

# run multi-service orchestrate example
# the main suite is the sauce connect instance + six wiremock instances as services
# 
# live logs are usuful for development and exploratory testing
#   console logs are also available via saucectl imagerunner logs
#   https://docs.saucelabs.com/dev/cli/saucectl/imagerunner/logs/
saucectl run --live-logs --region ${SAUCE_REGION} --config .sauce/config-module-04-02.yml
```


```sh
# start a new shell
env |grep SAUCE
#export SAUCE_REGION=
#export SAUCE_USERNAME=
#export SAUCE_ACCESS_KEY=

# set the tunnel name from the my_tunnel_name file we created earlier
export SAUCE_TUNNEL_NAME=$(head -n 1 my_tunnel_name)
echo ${SAUCE_TUNNEL_NAME}

# check sauce connect status, will only return id for running tunnels
# once the tunnel id is returned
#   it means the wiremocks were all started and passed the health check
#   and sauce connect is up and running
#
# the tunnel.lib is an API wrapper
#   you can re-implement or extend as needed
#   it calls methods documented at the link below
#   https://docs.saucelabs.com/dev/api/connect/ 
source ./usr/tunnel.lib
tunnel_id_get_by_name ${SAUCE_TUNNEL_NAME}


# start xcuitest/espresso tests
#   or other test suite
#   make sure to use the tunnel name as set earlier
#   
#   as you access the tunnel and wiremocks, log messages will show on the orchestrate run


# after your tests suite is complete
#   gracefully stop the orchestrate instance
#   the same library sourced earlier can be used to simplify this step
# 
# stopping the tunnel will also stop the orchestrate run and the wiremock instances
# json output will be returned to validate if the command was successful
tunnel_stop_by_name ${SAUCE_TUNNEL_NAME}


# the saucectl process in the first shell
#   which submitted the orchestreate run
#   should stop gracefully
#   and the orchestrate run should be marked as successfull
#
#   check the exit code to validate
#   echo $?
```


#### 4.2b Async Mode Orchestrate+ Standalone Services & Sauce Connect 

This is the same use case as 4.2, but we will invoke the Orchestrate `saucectl` process with the `async` parameter.  
The health of the Orchestrate pod and post-run collection of the console output are operational critical.  

This is just one method to demonstrate using the `async` option to suppport a synchronous pipeline.
Other methods exist.  
i.e. Shell job control is an excellent option. Use a method most familiar, comfortable, efficient for your team's DevOps processes and experiences.

Please see [`README-module-04b`](README-module-04b) for the async example workflow.


#### 4.3 Orchestrate+ Proxy Party Geo-IP Edition

Deploy multiple Sauce Connect instances where browsers and devices are proxied.
Requires a WonderProxy account.


```sh
[[ -z ${SAUCE_USERNAME} || -z ${SAUCE_ACCESS_KEY} || -z ${SAUCE_REGION} ]] \
    && printf "\nPlease set environment variables for "SAUCE_USERNAME", "SAUCE_ACCESS_KEY", and "SAUCE_REGION".\n"

[[ -z ${WONDERPROXY_USER} || -z ${WONDERPROXY_TOKEN} ]] \
    && printf "\nPlease set environment variables for "WONDERPROXY_USER" and "WONDERPROXY_TOKEN".\n"

export SAUCE_TUNNEL_NAME="sc-monitor-$(uuidgen)"
saucectl run --live-logs --region ${SAUCE_REGION} --config .sauce/config-module-04-03.yml


# open sauce labs dashboard
# select tunnel before starting browser/device session

# stop the monitor sauce connect instance or cancel the orchestrate run


# swap the sc monitor instance for your automated tests suite
#   set the tunnelName config as noted in link below
#   values are in the orchestrate configuration
#   https://docs.saucelabs.com/dev/test-configuration-options/#tunnelname
```

---


## Workshop Summary

Congratulations! — You have completed the _first_ part of this workshop!

<br>


- Module 1
  - 1.2 Runner Configuration — Environment Variable(s)        
- Module 2
  - 2.1 Runner Configuration — Triage Error  
  - 2.2 Runner Configuration — Collect Orchestrate Container Artifact  
  - 2.3 Imagerunner Command — Download Orchestrate Container Artifact  
  - 2.4 Imagerunner Command — Print Orchestrate Container Console Log
  - 2.5 Runner Configuration — Entrypoints & Files
- Module 3
  - 3.1 Local Container — Interactive Session 
  - 3.2 Local Container — Working Command
  - 3.3 Local Container — Working Entrypoint
  - 3.4 Orchestrate Container — Working Entrypoint
- Module 4
  - 4.1 Orchestrate Pod — Services & Sauce Connect
  - 4.2a Orchestrate Pod — Standalone Services & Sauce Connect
  - 4.2b 
  - 4.3 Orchestrate Pod — Proxy Party Geo-IP Edition
  
<br>

### PART II — _Self Guided Edition_
  - Reasearch any blockers that you hit.
  - Walkthrough the entire workshop a 2nd time by yourself.
    - Make sure you're on the latest commit of this repo! <!-- git usage is a different workshop -->
    - Go through all the modules in order.
    - Execute all the commands.
    - Explain your answers.
    - Describe your thought process.
    - All the notes are in this file as HTML comments <!-- see -->
    - Send feedback! <!-- please, thank you! -->
  - Supplement this workshop with [The Missing Semester](https://missing.csail.mit.edu/).



<br> 

### PART III — _BE THE GUIDE_
  - Host this workshop for a colleague.
    - Walk them through the entire workshop.
      - Make sure you're on the latest commit of this repo!
    - This will help you become a better guide to others.
    - If they are blocked...
      - Provide the solution and explain it.
      - Direct them to the exact command needed to move on to the next step.
      - If they cannot drive further, share your screen and complete the workshop.
    - All the notes are in this file as HTML comments <!-- see -->
    - Send feedback! <!-- please, thank you! -->


<br>

---

# Appendix 

## Resources


- [Getting Started with Sauce Orchestrate](https://docs.saucelabs.com/orchestrate/getting-started/)
- [saucectl Configuration Options for Sauce Orchestrate](https://docs.saucelabs.com/orchestrate/saucectl-configuration/)
- [Sauce Orchestrate Internals](https://opensaucelabs.atlassian.net/wiki/spaces/SE/pages/145195009/Sauce+Orchestrate)

> Images are built with [kmissoumi/photon-images](https://github.com/kmissoumi/photon-images) and [hosted on Docker Hub](https://hub.docker.com/u/suncup).


## Other Commands

```
docker history --human --format "{{.CreatedBy}}: {{.Size}}" ${imageName}
docker diff # compare two images
```

```
# https://github.com/wagoodman/dive
dive ${imageName}
```



<!-- generate .tree via `tree -aI 'node_modules|artifacts|_|*.tar|.git|.tree' > .tree` -->