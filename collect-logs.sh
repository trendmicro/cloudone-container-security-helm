#!/bin/bash
#
# a helper script to fetch Kubernetes settings and Trend Micro Cloud One container security logs.
#

RELEASE=${RELEASE:-trendmicro}
KUBECTL=kubectl
HELM=helm

#####
# check prerequisites
#####
command_exists () {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists $KUBECTL; then
  echo "No kubectl command found, exiting..."
  exit 1
fi

if ! command_exists $HELM; then
  echo "No helm command found, exiting..."
  exit 1
fi

CURRENT_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}')
CURRENT_NS=${CURRENT_NS:-trendmicro-system}
NAMESPACE=${NAMESPACE:-$CURRENT_NS}
NAMESPACE_PARAM="--namespace=$NAMESPACE"

PODS=$($KUBECTL get pods "$NAMESPACE_PARAM" -o=jsonpath='{range .items[*]}{.metadata.name}{";"}{end}' -l app.kubernetes.io/instance=$RELEASE)
if [ -z "${PODS}" ]; then
  echo "No container security pods are found in release '$RELEASE' in namespace '$NAMESPACE'.  You can use RELEASE and NAMESPACE environment variable to change its default settings."
  exit 1
fi

# Get Helm version since 'helm list' on Helm 3 does not display all namespaces unless specified. However, this flag does not exist in Helm 2
case X`helm version --template="{{.Version}}"` in
  Xv3.*)
    HELM_COMMAND="$HELM list --all-namespaces";;
  *)
    echo "Trend Micro Cloud One Container Security only supports Helm 3 or newer version, exiting..."
    exit 1
esac


# prepare the output folder
TIME=$(date +%s)
RESULTS_DIR="${RESULTS_DIR:-/tmp/container-security-${TIME}}"
MASTER_DIR="${RESULTS_DIR}/master"
mkdir -p "$MASTER_DIR/apps"
echo "Results folder will be: $RESULTS_DIR"

#####
# setting logs
#####
COMMANDS=( "version:$KUBECTL version"
           "components:$KUBECTL get componentstatuses"
           "events:$KUBECTL get events --all-namespaces"
           "storageclass:$KUBECTL describe storageclass"
           "helm:$HELM_COMMAND"
           "helm-status:$HELM status $RELEASE $NAMESPACE_PARAM"
           "nodes:$KUBECTL describe nodes"
           "podlist:$KUBECTL get pods --all-namespaces"
           "daemonsets: $KUBECTL get ds --all-namespaces"
           "container-security-get:$KUBECTL get all --all-namespaces -l app.kubernetes.io/instance=$RELEASE"
           "container-security-desc:$KUBECTL describe all --all-namespaces -l app.kubernetes.io/instance=$RELEASE"
           "container-security-desc-netpol:$KUBECTL describe networkpolicy --all-namespaces -l app.kubernetes.io/instance=$RELEASE"
           "container-security-secrets:$KUBECTL get secrets --all-namespaces -l app.kubernetes.io/instance=$RELEASE"
           "container-security-config:$KUBECTL describe configmap --all-namespaces -l app.kubernetes.io/instance=$RELEASE"
           "container-security-getvalidatewebhooks:$KUBECTL get ValidatingWebhookConfiguration --all-namespaces -l app.kubernetes.io/instance=$RELEASE"
           "container-security-descvalidatewebhooks:$KUBECTL describe ValidatingWebhookConfiguration --all-namespaces -l app.kubernetes.io/instance=$RELEASE")

echo "Fetching setting logs..."
for command in "${COMMANDS[@]}"; do
    KEY="${command%%:*}"
    VALUE="${command##*:}"
    echo "Command:" "$VALUE" > "$MASTER_DIR/$KEY.log"
    echo "====================================" >> "$MASTER_DIR/$KEY.log"
    $VALUE >> "$MASTER_DIR/$KEY.log" 2>&1
done

#####
# application logs
#####
for pod in $(echo "$PODS" | tr ";" "\n"); do
    CONTAINERS=$($KUBECTL get pods "$NAMESPACE_PARAM" "$pod" -o jsonpath='{.spec.initContainers[*].name}')
    for container in $CONTAINERS; do
        echo "Fetching container security logs... $pod - $container"
        $KUBECTL logs "$NAMESPACE_PARAM" "$pod" -c "$container" > "$MASTER_DIR/apps/$pod-$container.log"
        # check for any previous containers, this would indicate a crash
        PREV_LOGFILE="$MASTER_DIR/apps/$pod-$container-previous.log"
        if ! $KUBECTL logs "$NAMESPACE_PARAM" "$pod" -c "$container" -p > "$PREV_LOGFILE" 2>/dev/null; then
            rm -f "$PREV_LOGFILE"
        fi
    done

    # list containers in pod
    CONTAINERS=$($KUBECTL get pods "$NAMESPACE_PARAM" "$pod" -o jsonpath='{.spec.containers[*].name}')
    for container in $CONTAINERS; do
        echo "Fetching container security logs... $pod - $container"
        $KUBECTL logs "$NAMESPACE_PARAM" "$pod" -c "$container" > "$MASTER_DIR/apps/$pod-$container.log"
        # check for any previous containers, this would indicate a crash
        PREV_LOGFILE="$MASTER_DIR/apps/$pod-$container-previous.log"
        if ! $KUBECTL logs "$NAMESPACE_PARAM" "$pod" -c "$container" -p > "$PREV_LOGFILE" 2>/dev/null; then
            rm -f "$PREV_LOGFILE"
        fi
    done
done

echo "Results folder: $RESULTS_DIR"
