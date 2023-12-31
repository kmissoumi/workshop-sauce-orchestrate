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
  e.g. saucectl run --env NASA_API_KEY=5f95f9099fed4797bc26bd3cbb5097c9
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


```
saucectl run --config .sauce/config-module-01.yml
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


```
saucectl run --config .sauce/config-module-02-01.yml
```


#### 2.2 Artifacts 
- Collect the log from the container.
  - Update the configuration file to download the error log.
  - Read about the configuration key named [artifacts](https://docs.saucelabs.com/orchestrate/saucectl-configuration/#artifacts).
  - Make a copy of the existing configuration and add the needed key to save a custom artifact.
    - We want to collect the error log that was referenced in the console output.

> This same configuration can be used to download custom reports or test artifacts that are written to the container.

```
saucectl run --config .sauce/config-module-02-02.yml
```

#### 2.3 Download
- Re-run with the new configuration.
  - Where is the file?
    - Copy the runID from the last run.
    - Export the runID.
  `export runID=`
    - Run the command listed below and then open the log file.
    <!-- copy the runID from the previous runner output, type export and then double click the runID in the terminal and do a copy/paste, less typing here, it should be fast -->  
  

```
saucectl imagerunner artifacts download ${runID} "*" --target-dir artifacts/runID-${runID}
```

#### 2.4 Logs
- What does the log from the container tell us?
  - Is this different than what the log from `saucectl` told us?
  - Pull the console output for this run from `saucectl`.
    - Confirm the answer needed was not already provided.
      <!-- at the previous step, did enter your runID directly or did you export it? -->

```
saucectl imagerunner logs ${runID} 
```


#### 2.5 Triage
- Where is the issue with the test?
  - How can we triage this issue further?
  - Can you collect all the available paths from the image? 
  - Create a new configuration file.
    - This time change the entry point to run the command listed below.  
`env`

```
saucectl run --config .sauce/config-module-02-05-01.yml
```

  - Try the command below next.  
    - Run this new configuration.
    - What output do you collect?
    - What does this tell you?
    - Have you confirmed what the issue is?
    - Do you now think the issue is related to something else?  
`ls -la demo-webdriverio`

```
saucectl run --config .sauce/config-module-02-05-02.yml
```

  - What if the output was truncated? <!-- it isn't, probably, I dunno -->
  - What about running a script with multiple commands? <!-- this is just an example of what is possible. it is useful to understand all the other bits -->
    - Update the configuration to send the output to a log.
    - Update the configuration to automatically download the log.
  


```
saucectl run --config .sauce/config-module-02-05-03.yml
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
  
```
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

```
saucectl run --config .sauce/config-module-03-01.yml
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