# Sauce Orchestrate Workshop

#### 4.2b Async Mode Orchestrate+ Standalone Services & Sauce Connect 

This use case is same as 4.2a, but we will invoke the Orchestrate `saucectl` process with the `async` parameter.  
The health of the Orchestrate pod and post-run collection of the console output are operational critical.  

This example is one demonstration method using the `async` option to support a synchronous pipeline.
Other methods exist. Use the method most familiar, comfortable, efficient for your team's DevOps processes and experiences.
e.g., Shell job control.

```sh
# tunnel name must be unique
# the orchestrate saucectl configuration passes this environment variable to set the tunnel's name
# the main suite, will reference this variable when starting the tunnel in the Orchestrate pod
#
# local-env (saucectl-config) > orchestrate-pod-env > suite-container (sc-config)
#
# said another way, the Orchestrate pod does NOT consume this tunnel
#   it is for the browsers and devices to reach our WireMock services
#
# this example generates a UUID to ensure the tunnel name is unique
export SAUCE_TUNNEL_NAME="wiremock-net-$(uuidgen)"


# run multi-service orchestrate example
#   the main suite is the sauce connect instance + six wiremock instances as services
# 
# use the async parameter
#   https://docs.saucelabs.com/dev/cli/saucectl/run/#--async
# 
# did the orchestrate saucectl process start with success?
saucectl run --async --no-color --region ${SAUCE_REGION} --config .sauce/config-module-04-02.yml
[[ $? != 0 ]] \
  && printf 'ERROR: Request to start Orchestrate session started NOTOK!\n' \
  || printf 'INFO: Request to start Orchestrate session started OK!\n'


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
tunnelId=$(tunnel_id_get_by_name)
[[ -z ${tunnelId} ]] \
  && printf 'WARN: No running tunnel with name %s found.\n' ${SAUCE_TUNNEL_NAME} \
  || printf 'INFO: Tunnel %s with ID=%s is running OK!\n' ${SAUCE_TUNNEL_NAME} ${tunnelId}


# if the tunnel is running, we can get the runID via the tunnel's metadata
orchestrateRunId=$(tunnel_metadata_get_so_runid_by_hostname)
[[ -z ${orchestrateRunId} ]] \
  && printf 'WARN: No Orchestrate runID for tunnel with name %s found.\n' ${SAUCE_TUNNEL_NAME} \
  || printf 'INFO: Tunnel %s has Orchestrate runID=%s\n' ${SAUCE_TUNNEL_NAME} ${orchestrateRunId}


# we can check the status of all running Orchestrate sessions
saucectl imagerunner list --region ${SAUCE_REGION} --out json \
  |jq -r '.content[]|select(.status == "Running")'

# we can check the status of the specific Orchestrate session using the runID
saucectl imagerunner list --region ${SAUCE_REGION} --out json \
  |jq -r --arg orchestrateRunId ${orchestrateRunId} '.content[]|select(.id == $orchestrateRunId)'


# start xcuitest/espresso tests
#   or other test suite
#   make sure to use the tunnel name as set earlier
#  


# after your tests suite is complete
#   gracefully stop the orchestrate instance
#   the same library sourced earlier can be used to simplify this step
# 
# stopping the tunnel will also stop the orchestrate run and the wiremock instances
# json output will be returned to validate if the command was successful
tunnel_stop_by_name


# now collect the orchestrate session's console logs
#   include the console logs as part of the pipeline test artifacts
#
#   the orchestrate session MUST be complete before collecting the console log
#   for triage and exploratory work, run the Orchestrate saucectl process
#       without --async
#       with --livelogs 
saucectl imagerunner logs ${orchestrateRunId} --region ${SAUCE_REGION} > ${orchestrateRunId}-orchestreate-console.log
```

