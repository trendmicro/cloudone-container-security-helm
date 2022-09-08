# Trend Micro Cloud One Container Security Helm Chart

## Getting started

### Installing Helm

Trend Micro Cloud One Container Security components use the `helm` package manager for Kubernetes.

#### Helm 3

Helm 3 or later is supported when installing Trend Micro Cloud One - Container Security components.
To get started, see the [Helm installation guide](https://helm.sh/docs/intro/install/). Installing Helm 3 should only require you to run one command.

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

### Upgrade a Trend Micro Cloud One Container Security deployment

To upgrade an existing installation in the default Kubernetes namespace to the latest version:

```sh
  helm upgrade \
    --values overrides.yaml \
    --namespace ${namespace} \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz
```

**Note**: Helm will override or reset values in `overrides.yaml`. If you want to use the values you had previously, use the [--reuse-valeus](https://helm.sh/docs/helm/helm_upgrade/) option during a Helm upgrade:

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

## Advanced topics

### Install a specific version of the Container Security helm chart

If you want to install a specific version you can use the archive link for the tagged release. For example, to install Trend Micro Cloud One Container Security helm chart version 2.3.1, run the following command:

```sh
  helm install \
    --values overrides.yaml \
    --namespace ${namespace} \
    --create-namespace \
    trendmicro \
    https://github.com/trendmicro/cloudone-container-security-helm/archive/2.3.1.tar.gz
```

### Enabling or disabling a specific component

If desired, specifics components of the Container Security helm chart can be enabled or disabled individually using an overrides file.
For example, you can choose to enable the runtime security component by including the below in your `overrides.yaml` file:
```yaml
  cloudOne:
    runtimeSecurity:
      enabled: true
```

### Configure Container Security to use a proxy

You can configure Container Security to use a socks5 proxy by setting the `httpsProxy` value. It is possible to use an http proxy, **but the runtime feature will only work with socks5 proxies**.
For example, you can configure a socks5 proxy with authentication in your `overrides.yaml` file this way:
```
proxy:
  httpsProxy: socks5://10.10.10.10:1080
  username: user
  password: password  
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
Gather logs using the following command:

```sh
./collect-logs.sh
```

The following environment variables are supported for log collection:

| Environment variable      | Description                             | Default                                                                                        |
| ------------------------- |:----------------------------------------|:-----------------------------------------------------------------------------------------------|
| RELEASE                   | Helm release name                       | `trendmicro`                                                                         |
| NAMESPACE                 | The namespace that the helm chart is deployed in | Current namespace declared in `kubeconfig`. If no namespace setting exists in `kubeconfig`, then `trendmicro-system` will be used. |
