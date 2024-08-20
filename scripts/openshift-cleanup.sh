#!/bin/bash

# Define the ServiceAccount name
SA_NAME="scanner-trendmicro-container-security"
# Define the cluster binding name
CLUSTER_ROLE_BINDING_NAME="scan-job-rolebinding"
# Define the user or context for deletion
DELETE_USER="backplane-cluster-admin"

# List all namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Delete cluster role binding if it exists
cluster_role_binding_exists=$(kubectl get clusterrolebinding "$CLUSTER_ROLE_BINDING_NAME" --ignore-not-found -o jsonpath='{.metadata.name}')
if [ "$cluster_role_binding_exists" == "$CLUSTER_ROLE_BINDING_NAME" ]; then
    echo "Deleting ClusterRoleBinding $CLUSTER_ROLE_BINDING_NAME"
    # Delete the ClusterRoleBinding
    oc delete clusterrolebinding "$CLUSTER_ROLE_BINDING_NAME" --as "$DELETE_USER"
fi

# Iterate through each namespace and check for the ServiceAccount
for ns in $namespaces; do
    sa_exists=$(kubectl get serviceaccount -n "$ns" "$SA_NAME" --ignore-not-found -o jsonpath='{.metadata.name}')
    if [ "$sa_exists" == "$SA_NAME" ]; then
        echo "Deleting ServiceAccount $SA_NAME in namespace $ns"
        # Delete the ServiceAccount
        oc delete sa "$SA_NAME" --as "$DELETE_USER" -n "$ns"
    fi
done
