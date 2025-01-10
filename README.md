# Trend Micro Cloud One Container Security Helm Chart

## Getting started

### Installing Helm

Trend Micro Cloud One Container Security components use the `helm` package manager for Kubernetes.

Helm 3 or later is supported when installing Trend Micro Cloud One - Container Security components.
To get started, see the [Helm installation guide](https://helm.sh/docs/intro/install/).

### Kubernetes Network Policies with Container Security Continuous Compliance

Container Security Continuous Compliance enforces policies by leveraging [Kubernetes network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to perform isolation mitigation. Network policies are implemented by the [network plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/).

To install Container Security, a network plugin with NetworkPolicy support is required to allow for network isolation mitigation. 

- In Amazon Elastic Kubernetes Service (Amazon EKS), the [Calico network plugin](https://docs.aws.amazon.com/eks/latest/userguide/calico.html) can be used as network policy engine.
- In OpenShift 4.x, [OpenShift SDN](https://docs.openshift.com/container-platform/4.7/networking/network_policy/about-network-policy.html) supports using network policy in its default network isolation mode.
- In Azure Kubernetes Service (AKS), network policy are supported by [Azure Network Policies or Calico](https://docs.microsoft.com/en-us/azure/aks/use-network-policies).
- In Google Kubernetes Engine (GKE), you could enable [network policy enforcement](https://cloud.google.com/kubernetes-engine/docs/how-to/network-policy) for a cluster.

**Note**: If you are running Container Security in a **Red Hat OpenShift** environment, network isolation mitigation is only supported for pods whose security context is acceptable by oversight controller's SecurityContextConstraint.  If you want to let Container Security isolate pods that are not allowed by default, you can use overrides.yaml to override the default setting.

By default, Container Security Continuous Compliance will create a Kubernetes network policy on your behalf. If you want to create it manually, follow the steps below:
1. Change the value of `cloudOne.oversight.enableNetworkPolicyCreation` to `false`, as seen below:

```
  cloudOne:
    oversight:
      enableNetworkPolicyCreation: false
```

2. Create a network policy with `matchLabels` set to `trendmicro-cloud-one: isolate` in your desired namespaces. 

```
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    labels:
      app.kubernetes.io/instance: trendmicro
    name: trendmicro-oversight-isolate-policy
  spec:
    podSelector:
      matchLabels:
        trendmicro-cloud-one: isolate
    policyTypes:
    - Ingress
    - Egress
```

**Warning**: The network policy with matchLabels `trendmicro-cloud-one: isolate` must exist in each application namespaces in order to perform proper isolation mitigation.

### Getting a Cloud One API Key

To use the Trend Micro Cloud One Container Security components with your Kubernetes cluster an API key is required to be able to communicate with _Trend Micro Cloud One Container Security_.

To obtain an API key:
1. Navigate to the _Trend Micro Cloud One Container Security_ console using https://cloudone.trendmicro.com.

2. Go to [Add a cluster](https://cloudone.trendmicro.com/docs/container-security/cluster-add/).

3. Give your Kubernetes cluster a unique name. 

4. Copy your API key, as it will be used during the installation process.

### Using automated cluster registration

Instead of individually registering each cluster, Trend Vision One Container Security users can configure automated cluster registration.

To use automated cluster registration:
1. Navigate to the _Trend Micro Vision One_ console using https://portal.xdr.trendmicro.com/

2. Create a Vision One API Key with a role that contains only the "Automatically register cluster" permission

3. Put the Vision One API Key into a secret called `trendmicro-container-security-registration-key`

4. Install the Container Security Helm chart using the values `cloudOne.clusterRegistrationKey: true` and `cloudOne.groupId=<your cluster group ID>`.

### Override configuration defaults

Helm uses a file called `values.yaml` to set configuration defaults. You can find detailed documentation for each of the configuration options in this file.

You can override the defaults in this file by creating an `overrides.yaml` file and providing the location of this file as input during installation. The `cloudOne.APIKey` should be overridden in the `overrides.yaml` file. 

**Note**: If you create a file to override the values, make sure to copy the structure from the chart's `values.yaml` file. You only need to provide the values that you are overriding.

### Installing the Container Security Helm chart

1. Create a file called overrides.yaml that will contain your cluster-specific settings. You can find these values in the Container Security console or Container Security API when creating a cluster. The [Values.yaml](values.yaml) file can be used as a reference when creating your overrides file.

2. Use `helm` to install Container Security components with your cluster-specific settings. We recommend that you run Container Security in its own namespace. 

To install Container Security chart into an existing Kubernetes namespace, use the `--namespace` flag with the `helm install` command:

```sh
  helm install \
    --values overrides.yaml \
    --namespace ${namespace} \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz
```

In the example below, we create a new namespace by using `helm`'s `--create-namespace` option: 

```sh
  helm install \
    --values overrides.yaml \
    --namespace trendmicro-system \
    --create-namespace \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz
```

For more information about `helm install`, see the [Helm installation documentation](https://helm.sh/docs/helm/helm_install/).

**Note**: If you are running Container Security in a pure **AWS EKS Fargate** environment, you may need to adjust your Fargate profile to allow pods in a non-default namespace (ex: `trendmicro-system`) to be scheduled. See [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html) for more information on Fargate profiles.

**Note**: If you are running Container Security in a **Red Hat OpenShift** environment, the Helm Chart creates a [Security Context Constraint](https://docs.openshift.com/container-platform/4.7/authentication/managing-security-context-constraints.html) to allow Container Security components to have the minimum security context requirements to run.

**Note**: If you are running Container Security in a cluster where Pod Security Admission is available and you have runtime security enabled, ensure the namespace where Container Security is installed is using the [privileged Pod Security Standards policy](https://kubernetes.io/docs/concepts/security/pod-security-standards/#privileged).

### Upgrade a Trend Micro Cloud One Container Security deployment

To upgrade an existing installation in the default Kubernetes namespace to the latest version:

```sh
  helm upgrade \
    --values overrides.yaml \
    --namespace ${namespace} \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz
```

**Note**: Helm will override or reset values in `overrides.yaml`. If you want to use the values you had previously, use the [--reuse-values](https://helm.sh/docs/helm/helm_upgrade/) option during a Helm upgrade:

```sh
  helm upgrade \
    --namespace ${namespace} \
    --reuse-values \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz 
```

### Uninstall the Container Security Helm chart

You can delete all of the resources created by a helm chart using Helm's `uninstall` command:

**Warning**: `helm uninstall` and `kubectl delete namespace` are destructive commands, and will delete all of the associated resources.

```sh
  helm uninstall trendmicro --namespace ${namespace}
```

Use the `helm list --all-namespaces` command to list installed releases in all namespaces.

If you created a `trendmicro-system` namespace during install, and don't have any other components in the `trendmicro-system` namespace, you can delete the namespace by running `kubectl delete namespace trendmicro-system`. 

By default, Container Security Continuous Compliance will create a Kubernetes network policy for you. The created network policies will be cleaned up, even if the chart is uninstalled. To clean them up, run:

```sh
  kubectl delete networkpolicy -l app.kubernetes.io/instance=trendmicro --all-namespaces
```

**Warning**: If you have running Pods that are isolated by a network policy, removing the network policy will give them network access again.

## Documentation

- [Trend Micro Cloud One Container Security Documentation](https://cloudone.trendmicro.com/docs/container-security)
- [Trend Micro Vision One Container Security Documentation](https://docs.trendmicro.com/en-us/documentation/article/trend-vision-one-container-security)

## Advanced topics

### Install a specific version of the Container Security helm chart

If you want to install a specific version you can use the archive link for the tagged release. For example, to install Trend Micro Cloud One Container Security helm chart version 2.5.3, run the following command:

```sh
  helm install \
    --values overrides.yaml \
    --namespace ${namespace} \
    --create-namespace \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/2.5.3.tar.gz
```

### Enabling or disabling a specific component

If desired, specifics components of the Container Security helm chart can be enabled or disabled individually using an overrides file.
For example, you can choose to enable the runtime security component by including the below in your `overrides.yaml` file:
```yaml
  cloudOne:
    runtimeSecurity:
      enabled: true
```

### Managing Container Security policies with Policy as Code

To learn more about managing Container Security policies with custom resources and policy operator, see the [Policy as Code documentation](./docs/policy-as-code.md).

### Configure Container Security to use a proxy

You can configure Container Security to use either a socks5 proxy or http proxy by setting the `httpsProxy` value.
For example, you can configure a socks5 proxy with authentication in your `overrides.yaml` file this way:
```
proxy:
  httpsProxy: socks5://10.10.10.10:1080
  username: user
  password: password  
```

For http proxy, you can configure it this way:
```
proxy:
  httpsProxy: http://10.10.10.10:3128
  username: user
  password: password  
```

### Configure runtime vulnerability scanning for OpenShift

On OpenShift, new namespaces created after installing container security need to be configured by upgrading container security to create RBAC resources and provide scanners in the new namespaces the required privileges.

ServiceAccounts and cluster role bindings used to assign security context constraints to scanner pods will not be deleted on helm uninstall as some namespaces maybe privileged and require an admin role to delete. To delete all remaining rbac resources, you can run the following script with admin role:

```sh
./scripts/openshift-cleanup.sh
```

### Enable runtime security on AWS bottlerocket

You can run runtime security on AWS bottlerocket nodes by adding these configurations in your `overrides.yaml` file:
```yaml
securityContext:
  scout:
    scout:
      allowPrivilegeEscalation: true
      privileged: true
```

### Configure Runtime Container Interface

You can configure Container Security to customize container runtime interface.
For example, you can specify a custom path:

```
scout:
  falco:
    cri:
      socket: "/run/cri/containerd.sock"
```

You can also configure a custom path for k0s or k3s. For example:

```
scout:
  falco:
    k0s:
      socket: "/run/k0s/containerd.sock"
```

### Add capabilities to runtime vulnerability scanner

Runtime vulnerability scanner needs the privilege to access all directories and files in an image. `DAC_READ_SEARCH` is needed when the file permissions do not allow scanner to access the files or directories in an image. In this case, you can add `DAC_READ_SEARCH` to the `scanner`'s capabilities

```
securityContext:
  scanner:
    target:
      capabilities:
        add: ["DAC_READ_SEARCH"]
```

### Configure node selectors and tolerations for the Container Security components

To configure the scheduling of the Container Security components, you can set the `nodeSelector` and `tolerations` values in your `overrides.yaml` file:
```yaml
nodeSelector:
  defaults: # Node selector applied to all components except scanner pods (see below)
    kubernetes.io/arch: arm64

  admissionController: # Node selector applied to specific component
    kubernetes.io/arch: amd64

tolerations:
  defaults: # Tolerations applied to all components except scanner pods (see below)
  - key: kubernetes.io/arch 
    operator: Equal
    value: amd64
    effect: NoSchedule

  admissionController: # Tolerations applied to specific component
  - key: kubernetes.io/os
    operator: Exists
    effect: NoSchedule
```

For scanner pods, since they run images from the pods being scanned, you can configure the scanner to inherit the node selectors and tolerations from the owner resource (ie. deployment, daemonset, pod, etc.):
```yaml
nodeSelector:
  inheritNodeSelectorScanner: true # Inherit node selector from the owner resource (default: false)

  filterNodeSelectorScanner: # Only inherit node selector specified in the filter (default: all node selectors are inherited)
    kubernetes.io/arch: amd64

tolerations:
  inheritTolerationsScanner: true # Inherit tolerations from the owner resource (default: false)

  filterTolerationsScanner: # Only inherit tolerations specified in the filter (default: all tolerations are inherited)
  - key: kubernetes.io/arch 
    operator: Equal
    value: amd64
    effect: NoSchedule
```


### Configuring logging for the Container Security components

You can configure the logging for all components by setting the `logConfig` value in your `overrides.yaml` file:

```yaml
logConfig:
  logLevel: info # Sets the log verbosity level. Supported values are debug, info, and error. Overrides the logLevel set for each component
  logFormat: json # Sets the log encoder. Supported values are json and console
  stackTraceLevel: error # Sets the level above which stacktraces are captured. Supported values are info, error or panic
  timeEncoding: rfc3339 # Sets the time encoding format. Supported values are epoch, millis, nano, iso8601, rfc3339 or rfc3339nano
```

You can also configure the log level for each component individually by setting the `logLevel` value for the component in your `overrides.yaml` file:

```yaml
cloudone:
  admissionController:
    logLevel: debug
```

### Configuring Falco event outputs

You can enable Falco event outputs to stdout or syslog by setting values under `scout.falco` in your `overrides.yaml` file:

```yaml
scout:
  falco:
    stdout_enabled: true # Enable stdout output for Falco events. 
    syslog_enabled: true # Enable syslog output for Falco events
```

Note: Enabling stdout output will cause large amounts of logs to be generated. Enable these if the events are being consumed from the respective channel. Container security will only consume the events from the grpc channel.


### Configuring Splunk HEC token for Falco Custom Rules

To learn more about configuring the Splunk HEC token for falco custom rules, see the Splunk HEC Secret docs [here](./docs/falco-splunk-hec-secret.md).

### Least Privileged mode

Falco runs in full privileged mode by default. For the sake of security, you can enable `least_privileged` to make Falco to run in the least privileged mode. In this case, Falco will be non-privileged container with minimum capabilities added. 

```yaml
scout:
  falco:
    least_privileged: true
```

## Troubleshooting

### Access logs
Most issues can be investigated using the application logs. The logs can be accessed using `kubectl`.

* Access the logs for the admission controller using the following command: 
```sh
  kubectl logs deployment/trendmicro-admission-controller --namespace ${namespace}
```

* Access the logs for the runtime security component using the following command, where container can be one of `scout`, or `falco`:
```sh
  kubectl logs daemonset/trendmicro-scout --namespace ${namespace} -c ${container}
```

* Access the logs for Oversight controller (Continuous Compliance policy enforcement) using the following command:
```sh
  kubectl logs deployment/trendmicro-oversight-controller [controller-manager | rbac-proxy] --namespace ${namespace}
```

* Access the logs for Usage controller using the following command:
```sh
  kubectl logs deployment/trendmicro-usage-controller [controller-manager | rbac-proxy] --namespace ${namespace}
```

### Collect support logs
To help debug issues reported in support cases, a log collection script is provided for customer use.

To enable debug logging, set the `logConfig.logLevel` to `debug` in the `overrides.yaml` file and upgrade the helm chart.
```yaml
logConfig:
  logLevel: debug
```

Gather logs using the following command:

```sh
./scripts/collect-logs.sh
```

The following environment variables are supported for log collection:

| Environment variable      | Description                             | Default                                                                                        |
| ------------------------- |:----------------------------------------|:-----------------------------------------------------------------------------------------------|
| RELEASE                   | Helm release name                       | `trendmicro`                                                                         |
| NAMESPACE                 | The namespace that the helm chart is deployed in | Current namespace declared in `kubeconfig`. If no namespace setting exists in `kubeconfig`, then `trendmicro-system` will be used. |

### Known Issue

1. Malware scanning is not supported in air-gapped environments.
2. Malware scanning is not supported in ARM64 environments.
