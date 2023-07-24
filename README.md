# Sauce Orchestrate Workshop

This workshop provides practical exercises and example workflows for Sauce Orchestrate.

Use Visual Code as your IDE.  
Explain your answers.  
Describe your thought process.

---

### Module 1


- 1.1 Inspect the `saucectl` configuration file listed below.  
  [`.sauce/config-module-01.yml`](.sauce/config-module-01.yml)
  - What environment variables does it expect?
    - Make sure you have all the environment variables specified set.
  - What image does it use?


- 1.2 Run run `saucectl` command below. 
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

- 2.1 Inspect the `saucectl` configuration file listed below.  
  [`.sauce/config-module-02-01.yml`](.sauce/config-module-02-01.yml)  
  - Describe what it does.  



- 2.2 Run run `saucectl` command below.
  - Describe what happened.
  - If successful, what did it do?
  - If unsuccessful, what does the error message say?
    - What does that mean?
    - How do you fix it?
    - What is the runID?
      - Write it down here.


```
saucectl run --config .sauce/config-module-02-01.yml
```


- 2.2 Collect the error from the container.
  - Update the configuration file to download the error log.
  - Read about the configuration key named [artifacts](https://docs.saucelabs.com/orchestrate/saucectl-configuration/#artifacts).
  - Make a copy of the existing configuration and add the needed key to save a custom artifact.
    - We want to collect the error log that was referenced in the console output.

> This same configuration can be used to download custom reports or test artifacts that are written to the container.

- 2.3 Re-run with the new configuration.
  - Where is the file?
    - Use the runID to download the file locally to inspect.

```
saucectl imagerunner artifacts download ${runID} "*" --target-dir artifacts/${runID} --region ${SAUCE_REGION}
```

- 2.4 What does the log from the container tell us?
  - Is this different than what the log from `saucectl` told us?
  - Pull the console output for this run from `saucectl`.
    - Confirm the answer needed was not already provided.


```
saucectl imagerunner logs ${runID} 
```

- 2.5 Where is the issue with the test?
  - How can we triage this issue further?
  - Can you collect all the available paths from the image? 
  - Create a new configuration file.
    - This time change the entry point to run the command listed below.  
`env`

    - Try the command below next.  
`ls -la`
      - Run this new configuration.
      - What output do you collect?
      - What does this tell you?
      - Have you confirmed what the issue is?
      - Do you now think the issue is related to something else?

    - Try the command below next.  
`tree`
      - Was the output truncated?
      - Update the configuration to send the output to a log.
      - Update the configuration to automatically download the log.

  - What about running a script with multiple commands?

```
saucectl run --config .sauce/config-module-02-05.yml
```
---


### Module 3

Up to this point we have not used Docker. We have not built an image.  
We have not looked at a DOCKER file.

Let's do the same investigation directly on the image.  
This provides us with an interactive session and will save a lot of time.

Keep everything as close as possible to the original configuration.  
Use the same variables passed in the `saucectl` configuration file.


### Part I
```
export imageName='suncup/photon-js:latest'
docker run -it \
    --platform linux/amd64 \
    --env SAUCE_USERNAME=${SAUCE_USERNAME} \
    --env SAUCE_ACCESS_KEY=${SAUCE_ACCESS_KEY} \
    --env SAUCE_REGION=${SAUCE_REGION} \
    --env SAUCE_BUILD_TYPE="Docker Local Dev" \
    ${imageName} \
    sh
```

### Part II

- Go through all the steps from module 2 in this interactive session.
  - Is the [`get-info.sh`](usr/get-info.sh) script there? 
  - What did you find?


### Part III

- Get the test to run directly from the container.
  - What should the _entrypoint_ be?
  - Fix it and re-run via `saucectl`.



```
saucectl run --config .sauce/config-module-03-01.yml
```

### Part IV 

- What is the one thing needed to run these commands?


---




### Module 4

Using `saucectl` with Sauce Orchestrate.

- Does anything need to change to work with Sauce Orchestrate?
- Do you need a new tunnel to reach the service under test?
- When do you need a new tunnel?
- What can you do to avoid having to use a tunnel to access any backend services?




### Appendix Other Commands

```
docker history --human --format "{{.CreatedBy}}: {{.Size}}" ${imageName}
docker diff # compare two images
```

```
# https://github.com/wagoodman/dive
dive ${imageName}
```

