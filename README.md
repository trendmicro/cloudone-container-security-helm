# Trend Micro Cloud One Admission Controller

## Getting started

### Installing Helm

Trend Micro Cloud One Admission Controller uses the `helm` package manager for Kubernetes.

#### Helm 3

We recommend using Helm 3 (version 3.0.1 or later) to install the Trend Micro Cloud One Admission Controller if this is possible for you.

There is a handy [guide](https://helm.sh/docs/intro/install/) that will help you get started. In most cases installing Helm 3 involves running a single command.

If you have already installed the Trend Micro Cloud One Admission Controller using Helm 2, you will need to migrate your install. The Helm folks have a helpful [blog post](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/) that details this process.

#### Helm 2

<details>
<summary>If you have to use Helm 2, you will need <code>helm</code> version <code>v2.14.1</code> or later. Expand this section for details.</summary>

There's a handy [quickstart](https://docs.helm.sh/using_helm/#quickstart) that will help you get started, or if you like living dangerously:

```sh
curl -L https://git.io/get_helm.sh | bash
```

Helm has a cluster-side component called `tiller` that needs to be installed as well.

Make sure that your `kubectl` context is set correctly to point to your cluster:

```sh
kubectl config current-context
```

_If your `kubectl` context is not pointing to your cluster, use `kubectl config get-contexts` and `kubectl config use-context` to set it, or if you are using Google Cloud Platform follow the instructions in the **Connect to the cluster** dialog available by clicking the **Connect** button beside your cluster information in the console._

Configure a service account for `tiller` and install:

```sh
kubectl create serviceaccount \
  --namespace kube-system \
  tiller

kubectl create clusterrolebinding tiller-cluster-role \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --service-account tiller
```

Use `helm version` to confirm that you have at least version `v2.14.1` of the client and server installed.

_Note: the commands above will give `tiller` full cluster administrator privileges. Review [Securing your Helm Installation](https://docs.helm.sh/using_helm/#securing-your-helm-installation) for help on what to consider when setting up Helm in your cluster._

</details>

### Getting a Cloud One API Key

To use the Admission Controller with your Kubernetes cluster an API key is required to be able to communicate with _Trend Micro Cloud One Container Security_.

To obtain an API key:
1. Navigate to the _Trend Micro Cloud One Container Security_ console using https://cloudone.trendmicro.com.

2. Proceed to the clusters page.

3. Add a cluster giving it a unique name which can identify your Kubernetes cluster for which the Admission Controller will be used. Upon registering the cluster, an API key will be provided for use in the installation process.

### Installing the Admission Controller

1. Create a file called overrides.yaml that will contain your cluster-specific settings.
    ```yaml
    cloudOne:
      ## API key to be used with Trend Micro Cloud One Container Security
      apiKey: YOUR-API-KEY-HERE
    ```

2. Use `helm` to install Trend Micro Cloud One Admission Controller with your cluster-specific settings:
    ```sh
    helm install \
      --values overrides.yaml
      trendmicro \
      https://github.com/trendmicro/cloudone-admission-controller-helm/archive/master.tar.gz
    ```

### Upgrading the Admission Controller

To upgrade an existing installation of Cloud One Admission Controller in the default Kubernetes namespace to the latest version:

```sh
helm upgrade \
  --values overrides.yaml \
  trendmicro \
  https://github.com/trendmicro/cloudone-admission-controller-helm/archive/master.tar.gz
```

### Uninstalling the Admission Controller

You can delete all of the resources created for the Admission Controller by running `helm delete`:

```sh
helm delete trendmicro
```

Use the `helm list` command to list installed releases.

**`helm delete` is a destructive command and will delete all of the associated resources. Use with care.**

## Documentation

- [Trend Micro Cloud One Container Security Documentation] - Coming soon

## Advanced topics

### Installing a specific version of the Admission Controller

If you want to install a specific version of the Admission Controller, you can use the archive link for the tagged release. For example, to install Trend Micro Cloud One Admission Controller 0.0.0, you can run:

```sh
helm install \
  --values overrides.yaml \
  trendmicro \
  https://github.com/trendmicro/cloudone-admission-controller-helm/archive/0.0.0.tar.gz
```

### Using an alternate Kubernetes namespace

To install the Admission Controller into an existing Kubernetes namespace that's different from the current namespace, use the `--namespace` parameter in the `helm install` command:

```sh
helm install \
  --namespace {namespace} \
  --values overrides.yaml
  trendmicro \
  https://github.com/trendmicro/cloudone-admission-controller-helm/archive/master.tar.gz
```

### Overriding configuration defaults

Helm uses a file called `values.yaml` to set configuration defaults. You can find detailed documentation for each of the configuration options in this file.

As described above, you can override the defaults in this file by creating an `overrides.yaml` file and providing the location of this file on the command line:

```sh
helm install \
  --values overrides.yaml
  trendmicro \
  https://github.com/trendmicro/cloudone-admission-controller-helm/archive/master.tar.gz
```

_If you create a file to override the values, make sure to copy the structure from the chart's `values.yaml` file. You only need to provide the values that you are overriding._

## Troubleshooting

### Basic issues
Most issues can be investigated using the Admission Controller logs. The Admission Controller logs can be accessed using Kubectl with the following command:
```sh
kubectl logs deployment/trendmicro-admission-controller
```
