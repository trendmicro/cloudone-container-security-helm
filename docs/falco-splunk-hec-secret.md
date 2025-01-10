
# Falco http_output with Splunk HEC token in a secret

## Preconditions

### Splunk HEC token is added as a secret

A secret *splunk-hec-secret* is added into namespace *trendmicro-system* with key *hec_secret* containing Splunk HEC token: 

> *trendmicro-system* is a default namespace to deploy this chart.
> Normally, it is created during helm chart deployment with *--create-namespace* helm flag.
> If this chart is not deployed yet, the namespace may be missed.
> 
> Add the namespace before creating a secret:
> ```sh
> kubectl create namespace trendmicro-system
> ```

To create a secret:
```sh
kubectl create secret \
generic splunk-hec-secret \
--from-literal=hec_secret={Splunk HEC token} \
--namespace trendmicro-system
```

## Setup

### enable runtimeSecurity and custom rules

*.runtimeSecurity.enabled*
*.runtimeSecurity.customRules.enabled*

### set Splunk HEC token authorization secret name

*customRules.output.splunk.hecTokenSecretName* specify a name of a secret which contains Splunk HEC token

Example:
```yaml
    runtimeSecurity:
        enabled: true
        customRules:
          enabled: true
          output:
                json: true
                splunk:
                    url: 	https://indexer.trend-us-1.c1splunk.trendmicro.com:8088/services/collector/raw?sourcetype=serhiip
                    headers:
                    - "X-Splunk-Request-Channel: b2b7e14f-e8a2-4bb5-a422-434611bc6ecb"
                    # - "Authorization: Splunk 123"
                    hecTokenSecretName: 'splunk-hec-secret'
```

### remove existing Authorization header(s)

Helm chart automatically adds required Splunk Authorization headers , no other auth headers needed.

### validate

```sh
helm template https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz  --dry-run=server --values overrides_hec_secret.yaml --debug --namespace trendmicro-system > manifest.yaml
```

## Errors

### secret is missing

Its an error if secret is missing when *runtimeSecurity.customRules.output.splunk.auth_use_hec_token* is true.
Add a secret as described above.

### extra Authorization headers for Splunk

Its an error if other Authorization headers are added when *runtimeSecurity.customRules.output.splunk.auth_use_hec_token* is true.
Remove extra Authorization headers.
