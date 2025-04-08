# ruleFiles from OCI repository

## Configuration

TrendMicro helm chart can be configured to automatically download and install ruleFiles from OCI artifacts.

This functionality is off by default.

To enable automatic installation of ruleFiles from OCI repositories, add the following sections into overrides: 

```yaml
cloudOne: 
...
  runtimeSecurity:
    enabled: true
    customRules:
      enabled: true
      output:
        json: true
        splunk:
          url: {splunk url}
          headers:
            - "X-Splunk-Request-Channel: {splunk channel id}"
          hecTokenSecretName: 'splunk-hec-secret'      
      ociRepository:
        enabled: true
        ruleFiles:
          - shell_in_container_serhiip_0_0_5.yaml
          - falco_rules.yaml
        artifactUrls:
          - ghcr.io/falcosecurity/rules/falco-rules:latest
          - public.ecr.aws/t9h5t7r4/serhiip/falcoctl:0
        basicAuthTokenSecretName: customrules-falcoctl-registry-auth-basic-missing-repo
      params:
        clusterName: "optional cluster name for splunk event field cluster_name"

```
**NOTE: these fields are subject to change**

Section `cloudOne.runtimeSecurity.customRules.ociRepository.artifactUrls` is a list of OCI repository URLs to pull artifacts from.
For URL format, see [falcoctl push](https://github.com/falcosecurity/falcoctl?tab=readme-ov-file#falcoctl-registry-push).

Section `cloudOne.runtimeSecurity.customRules.ociRepository.ruleFiles` is a list of filenames, to be continuously monitored as OCI artifacts.
Each file is expected to be a valid falco rulefile. There is no restrictions on how files are distributed between artifacts. A single artifact may contain all listed files or multiple artifacts may contain some of them. falco ignores files not listed by `.ociRepository.ruleFiles`.

Consult [falcoctl registry](https://github.com/falcosecurity/falcoctl?tab=readme-ov-file#falcoctl-registry) for details how to push artifacts into OCI repo using falcoctl.

Section `cloudOne.runtimeSecurity.customRules.ociRepository.basicAuthTokenSecretName` is a string naming a kubernetes secret inside `trendmicro-system` namespace. The secret is expected to include `falcoctl` key, its value is interpreted as basic auth credentials for private OCI repos. The format is the same as falcoctl env variable `FALCOCTL_REGISTRY_AUTH_BASIC`, described here [falcoctl environment variables](https://github.com/falcosecurity/falcoctl?tab=readme-ov-file#falcoctl-environment-variables).

Use of this secret:
- with `.artifactUrls` only listing public repos, this field may be empty string or just skipped
- with `.artifactUrls` listing some/all private repos, this field is required, the secret is required in the namespace `trendmicro-system`

NOTE: its a deployment error if `.basicAuthTokenSecretName` is the secret specified but missed in namespace `trendmicro-system`.

NOTE: with `.basicAuthTokenSecretName` secret present but contains no key `falcoctl`, the scout pod will fail to start.

NOTE: with `.basicAuthTokenSecretName` secret present and contains key `falcoctl` but its value represents wrong credentials, falcoctl will not be able to install artifacts from private repos and falco will run with rules defined at deployment.

Section `cloudOne.runtimeSecurity.customRules.output.splunk` describes endpoint and credentials for `artifacts-accepted` and `artifacts-ignored` events. See [this](falco-splunk-hec-secret.md) for details.

NOTE: if splunk URL or auth headers are invalid, no events are expected, falco is not affected.

Optionally, section `.Values.scout.falco.ociRepository.logLevel` can be set to `info` to lower CPU impact. In this case `.output_fields.enabled_rules` will be empty. 

Section `cloudOne.runtimeSecurity.customRules.params.clusterName` is a string, optional, helps to identify which cluster sent splunk event; copied into splunk event `cluster_name` field; if not set, `cloudOne.clusterName` is used instead; if `cloudOne.clusterName` also not set, then `cluster_name` will be empty.

## OCI repo

OCI artifact consists of one or more rulesfiles, packaged, pushed into OCI repo, tagged with versions.
See [artifact push](https://github.com/falcosecurity/falcoctl?tab=readme-ov-file#falcoctl-registry-push) for details.

## Artifact Versions

Falcoctl supports floating versions, i.e. every time version "0.1.0" is pushed, extra tags added "0" and "0.1". It allows `.ociRepository.artifactUrls` to specify major versions only, i.e. "float over" fully qualified tags/versions and pickup the most recent version without reconfiguration. 
See [semver](https://semver.org/). 

## Possible Issues 

### Issue: help install/upgrade failed with `secret *** is expected`

Possible reason 1: secret `cloudOne.runtimeSecurity.customRules.ociRepository.basicAuthTokenSecretName`
is missing from `trendmicro-system` namespace.

Solution: follow recommendations in Section `cloudOne.runtimeSecurity.customRules.ociRepository.basicAuthTokenSecretName` on how to create the secret.

Possible reason 2: secret `cloudOne.runtimeSecurity.customRules.output.splunk.hecTokenSecretName`
is missing from `trendmicro-system` namespace.

Solution: follow [this](./docs/falco-splunk-hec-secret.md) on how to create the secret.

### Issue: scout pod status is `CreateContainerConfigError`

Additional info: cluster events include error `Error: couldn't find key falcoctl in Secret ...`

Possible reason: secret `cloudOne.runtimeSecurity.customRules.ociRepository.basicAuthTokenSecretName`
contains no key `falcoctl`.

Solution: add key `falcoctl`, follow recommendations in Section `cloudOne.runtimeSecurity.customRules.ociRepository.basicAuthTokenSecretName`

### Issue: OCI artifacts are not installed

Additional info: logs of container `falco-customrules` in `scout` pod show errors accessing OCI repo.

```sh
...
an error occurred while fetching descriptor from remote repository
...
```

or

```sh
...
Unable to pull config layer
...
```

Possible reason: secret `cloudOne.runtimeSecurity.customRules.ociRepository.basicAuthTokenSecretName` is malformed or defines wrong password or defines wrong repo URL.

Solution: double check the format is the same as falcoctl env variable `FALCOCTL_REGISTRY_AUTH_BASIC`, described here [falcoctl environment variables](https://github.com/falcosecurity/falcoctl?tab=readme-ov-file#falcoctl-environment-variables).
Double check repo URL and password is valid.

### Issue: OCI artifacts events are not visible in Splunk

#### Cause: Splunk HEC channel is not correct

Additional info: logs of container `falco-customrules` in `scout` pod show HEC messages being sent with no issues.

```sh
{"source":"oci artifacts falcoctl","cluster_name":
...
msg="HTTP response status: 200"
...
msg="{\"text\":\"Success\",\"code\":0,\"ackId\":11}"
...
```

Possible reason: section `cloudOne.runtimeSecurity.customRules.output.splunk.headers` includes no or incorrect header `X-Splunk-Request-Channel`. 

Solution: Double check Splunk request channel is valid.  

#### Cause: Splunk HEC token or Splunk URL is invalid

Additional info: logs of container `falco-customrules` in `scout` pod show HTTP errors while sending events to Splunk.

```sh
...
"unable to post data" error="Post \"https://wrong.url\": dial tcp: lookup wrong.url on {node IP}: no such host"
...
```

Possible reason: section `cloudOne.runtimeSecurity.customRules.output.splunk` is not correct. 

Solution: Provide valid URL and HTTP auth Bearer token as specified [here](./docs/falco-splunk-hec-secret.md). 

#### Cause: Splunk HEC info is not specified

Additional info: logs of container `falco-customrules` in `scout` pod show HTTP errors while sending events to Splunk.

```sh
...
invalid value "" for flag -H: header malformed, expect {key}:{value}
...
```

Possible reason: section `cloudOne.runtimeSecurity.customRules.output.splunk` is missing. 

Solution: Provide Splunk HEC info as specified [here](./docs/falco-splunk-hec-secret.md). 

### Issue: Rules from certain rulefile are not visible in Splunk event

Possible reason: section `cloudOne.runtimeSecurity.customRules.ociRepository.ruleFiles` is missing or specify rule files missing from artifact. 

Solution: make sure this section lists rules file actually present in OCI artifact. 


## How It Works

With `runtimeSecurity.enabled` and `customRules.enabled`, additional container `falco-customrules` is spawned.
This container runs falco configured to read ruleFiles `.ociRepository.ruleFiles`, watch for changes in those files and perform "hot restart".

With `ociRepository.enabled` false, the container `falco-customrules` will use rules configured at deployment.

With `ociRepository.enabled` true, the container `falco-customrules` will do the following:
- run an instance of falcoctl, configured to watch/download/install OCI artifacts from `.ociRepository.artifactUrls` ( every 6 hours, hardcoded )
- send messages to splunk when new artifact(s) is installed / accepted / ignored by falco 

When new version of an artifact is available, falcoctl installs it into a directory shared with falco.
Falco detects changes in files listed by `.ociRepository.ruleFiles`, performs "hot restart". Changes on the rest of files are ignored.

"Hot restart" is performed in 3 steps:
- falco validates a syntax of all rules found in files listed by `.ociRepository.ruleFiles`
- when syntax valid, falco begings to monitor those rules ( assuming artifacts are accepted )
- when any rule syntax is invalid ( this includes all rules, not limited to most recent change ), falco ignores changes and continues with most recent good configuration ( assuming recently installed artifacts are ignored )

`artifacts accepted` and `artifacts ignored` events are emitted accordingly, see below.

## Events

### Format

Two kinds of events are generated, determined by `output` field: 
- `artifacts accepted` , with `"output":"artifacts accepted"`
- `artifact ignored`, with `"output":"artifacts ignored"`

```json
{
    "source":"oci artifacts falcoctl",
    "cluster_name":"value of {cloudOne.runtimeSecurity.customRules.params.clusterName} or {cloudOne.clusterName}",
    "hostname":"{HOSTNAME of container}",
    "time":"2025-03-06T16:54:48Z",
    "output":"artifacts {accepted|ignored}",
    "output_fields":{
        "artifacts":[ 
            {
                "artifactName":"{artifact name including repo and tag}",
                "digest":"sha256:{artifact sha}",
                "type":"rulesfile"
                ...
            }, 
            ...
        ],
        "enabled_rules":[
            "Clear Log Activities",
            "Contact K8S API Server From Container",
            "PTRACE attached to process",
            ...
        ]
    }
}
```

### Logic

At container startup, event `artifacts accepted` is emitted with empty `output_fields.artifacts` and only rules defined at deployment time.

When new artifact(s) is installed and the rules are validated by falco during "hot restart", event `artifacts accepted` is emitted with recently installed artifacts listed by `output_fields.artifacts`  
and currently monitored rules listed by `.output_fields.enabled_rules` ( a superposition of all good rules installed so far from all artifacts since last container restart and rules configured at deployment ).

When falco detects some rules are malformed, event `artifacts ignored` is emitted with recently installed artifacts in `output_fields.artifacts` ( any artifact may be a source of a bad rule ) and currently monitored good rules listed by `.output_fields.enabled_rules`. List of recently installed artifacts is preserved until next successful "hot restart".

NOTE: when falco detects a malformed rule during "hot restart", falco interrupts "hot restart" and continues to run on last known good configuration; this configuration is represented by all `artifacts accepted` events since last container restart; once the error is fixed ( possibly by a new version of the artifact and bad rule is corrected ) , falco performs "hot restart" once again , producing `artifacts ignored` ( more bad rules ) or producing `artifacts accepted` ( all rules are good ).

NOTE: `output_fields.artifacts` lists all currently monitored rules. It is a superposition of rules from ruleFiles provided at deployment time and all artifacts installed since last container restart. To collect all installed artifacts, collect all `artifacts installed` events since most recent container restart ( this moment is marked by event `artifacts installed` with empty list of artifacts ).

NOTE: falcoctl never deletes ruleFiles. If a new version of an artifact no longer includes certain rulefile, its last known version ( along with rules it defines ) remains on a filesystem until container restart and still evaluated by falco. To effectively remove a rulefile, include empty file with the same name into the artifact.

### Implementation Details around Events

`falco-customrules` container maintains four lists of artifacts:
- `artifact-installed`, list of artifacts collected from falcoctl activity
- `artifact-accepted`, a snapshot of `artifact-installed` at the moment falco "hot restart" succeeded; content of `artifact-installed` is dropped at this moment to avoid be sent again
- `artifact-ignored`, a snapshot of `artifact-installed` at the moment falco "hot restart" failed; content of `artifact-installed` is preserved, pending next `artifact-accepted`
- `active-rules`, a list of rules reported by falco at the most recent successful startup; always indicates currently monitored rules

NOTE: `output_fields.artifacts` typically includes 1 artifact, a new version of some recently updated artifact. In case of malformed rules followed by possibly few corrections ( one or more new versions pushed ), multiple artifacts may be reported.
Another case when `output_fields.artifacts` includes multiple entries is at container startup: falcoctl pulls all artifacts simultaneously, causing a waterfall of changes, falco may pick those changes one by one or at once, producing one or more `artifact-installed` events.


