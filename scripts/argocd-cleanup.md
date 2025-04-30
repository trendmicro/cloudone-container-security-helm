# Argo CD Cleanup Script for Trend Micro Container Security

## Overview

Argo CD cleanup script helps clean up Trend Micro Container Security resources in your Kubernetes cluster.
```
./argocd-cleanup.sh
```

Run this script in these scenarios:
1. **Stuck Argo CD Applications**: When you've attempted to uninstall Trend Micro Container Security through Argo CD but the application is stuck in a "Deleting" state
2. **General Cleanup**: Even if the application is not in a deleting state  (i.e., after successful uninstallation), you want to ensure complete cleanup of all related resources

## Resources Cleaned Up

The script handles deletion of Trend Micro Container Security resources including:

- Argo CD application finalizers that may be preventing complete deletion
- Trend Micro image pull secrets distributed across all namespaces
- Trend Micro custom resource definitions (CRDs), specifically "workloadimages.cloudone.trendmicro.com"
- Service accounts, cluster role bindings, and cluster roles of Trend Micro  post-delete hooks
- Cleanup Jobs in the Trend Micro system namespace


## Prerequisites

- kubectl command-line tool installed and configured to connect to your cluster
- Appropriate permissions to delete cluster-wide resources

## Script Usage

1. Review and modify the variables at the top of the script if needed (default values mentioned below)
```bash
RELEASE_SERVICE=${RELEASE_SERVICE:-"Helm"}
CONTAINER_SECURITY_NAME=${CONTAINER_SECURITY_NAME:-"container-security"}
SOURCE_NAMESPACE=${SOURCE_NAMESPACE:-"trendmicro-system"}
ARGOCD_NAMESPACE="argocd"
```
2. Make the script executable: `chmod +x argocd-cleanup.sh`
3. Run the script: `./argocd-cleanup.sh`
4. Follow the prompts to confirm cleanup actions

