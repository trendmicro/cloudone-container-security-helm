# Managing Container Security policies with Policy as Code

With **Policy as Code**, define the Container Security policy and runtime ruleset as custom resources. The Container Security policy operator will manage the lifecycle of the policy resources, create and manage the policy in Vision One, and reconcile with the custom resources in the cluster. The policy operator also manages the policy and ruleset assignments to your cluster.

- **Version Control**: Policy resources can be managed with version control, allowing for easy tracking of changes
- **Access Control**: Policy resources can be managed with Kubernetes RBAC, ensuring that only authorized users can create or modify policies
- **CI/CD Integration**: Policy resources can be deployed using CI/CD or GitOps workflows alongside other Kubernetes manifests
- **Operator Management**: The policy operator handles the creation and management of policies and rulesets in Vision One, ensuring alignment with the policy custom resources in the cluster

Container Security supports the following policy resource types:

- **User Managed** - Policies created via the UI or API and managed by the user
- **Cluster Managed** - Policies created as custom resources in the cluster and managed by the policy operator. These policies can be managed through the custom resources in the cluster
  - Cluster Managed policy is read-only in Vision One UI and API and can only be managed through the custom resources in the cluster
  - Policy can not be deleted or unassigned from the cluster by the user in the Vision One UI or API
  - Policy can not be updated in the Vision One UI or API

## Getting Started

The policy operator is disabled by default. To enable, update the overrides.yaml file:

```yaml
cloudOne:
  policyOperator:
    enabled: true
    clusterPolicyName: <name of your policy custom resource>
```

To use policy as code, simply create the cluster policy and runtime ruleset custom resources in your cluster. To disable policy as code, delete the cluster policy and runtime ruleset custom resources.

Note: Only one cluster policy can be active at a time. The name of the cluster policy custom resource is specified in the overrides.yaml file and the policy operator will only reconcile the policy with the specified name.

To interact with the custom resources, use the following kind names:
- `clusterpolicy` for Cluster Policy
- `runtimeruleset` for Runtime Ruleset 

## Policy Custom Resource

The Cluster Policy defines the rules and exceptions for admission control and continuous oversight.The `ClusterPolicy` specification includes:

- **xdrEnabled**: Boolean for enabling XDR telemetry runtime rules
- **rules**: An array of deployment/continuous rules with the following attributes:
  - **type**: Type of policy rule
  - **action**: Action to take on rule match during admission control (one of: `log` or `block`)
  - **mitigation**: Action to take on rule match during continuous oversight (one of: `log`, `terminate`, or `isolate`)
  - **properties**: Rule properties object to specify additional properties for rule type
  - **namespaces**: Array of namespaces to apply the rule to. The rule will be applied to all namespaces if not specified
- **exceptions**: An array of policy exception rules to exclude certain images from policy enforcement. Each exception rule has the following attributes:
  - **type**: Type of policy exception rule. Supported types are:
    - `imageName`
    - `imageTag`
    - `imagePath`
    - `imageRegistry`
  - **properties**: Exception properties object to specify additional properties for exception rule
    - **operator**: Conditional operator to apply to the exception values. Supported operators are oneOf `equals`, `notEquals`, `contains`, `notContains`
    - **values**: Array of string values to match for the exception rule
  - **namespaces**: Array of namespaces to apply the exception rules to. The exceptions will be applied to all namespaces if not specified

### Policy Rule Types

<table>
  <tr>
    <th>Rule Type</th>
    <th>Description</th>
    <th>Rule Properties (Required)</th>
  </tr>
  <tr>
    <td>hostIPC</td>
    <td>Containers with <code>hostIPC</code> set to true</td>
    <td></td>
  </tr>
  <tr>
    <td>hostNetwork</td>
    <td>Containers with <code>hostNetwork</code> set to true</td>
    <td></td>
  </tr>
  <tr>
    <td>hostPID</td>
    <td>Containers with <code>hostPID</code> set to true</td>
    <td></td>
  </tr>
  <tr>
    <td>runAsNonRoot</td>
    <td>Security Context with <code>runAsNonRoot</code> set to false</td>
    <td></td>
  </tr>
  <tr>
    <td>privileged</td>
    <td>Security Context with <code>privileged</code> set to true</td>
    <td></td>
  </tr>
  <tr>
    <td>allowPrivilegeEscalation</td>
    <td>Security Context with <code>allowPrivilegeEscalation</code> set to true</td>
    <td></td>
  </tr>
  <tr>
    <td>readOnlyRootFilesystem</td>
    <td>Security Context with <code>readOnlyRootFilesystem</code> is false</td>
    <td></td>
  </tr>
  <tr>
    <td>podPortForward</td>
    <td>Creating a port-forward on a running pod</td>
    <td></td>
  </tr>
  <tr>
    <td>podExec</td>
    <td>Executing in/attaching to a running pod</td>
    <td></td>
  </tr>
  <tr>
    <td>containerCapabilities</td>
    <td>Container capability restrictions</td>
    <td><code>capabilityRestriction</code> - type of container capability restriction to enforce
        <ul>
            <li>restrict-nondefaults</li>
            <li>restrict-all</li>
            <li>baseline</li>
            <li>restricted</li>
        </ul>
    </td>
  <tr>
    <td>imageRegistry</td>
    <td>Containers running images matching registries</td>
    <td>
        <code>operator</code> - conditional operator to apply to values
        <ul>
            <li>equals</li>
            <li>notEquals</li>
            <li>contains</li>
            <li>notContains</li>
            <li>startsWith</li>
        </ul>
        <code>values</code> - array of string values to match for the rule type
    </td>
  </tr>
  <tr>
    <td>imageName</td>
    <td>Containers running images matching names</td>
    <td>
        <code>operator</code> - conditional operator to apply to values
        <ul>
            <li>equals</li>
            <li>notEquals</li>
            <li>contains</li>
            <li>notContains</li>
            <li>startsWith</li>
        </ul>
        <code>values</code> - array of string values to match for the rule type
    </td>
  </tr>
  <tr>
    <td>imageTag</td>
    <td>Containers running images matching tags</td>
    <td>
        <code>operator</code> - conditional operator to apply to values
        <ul>
            <li>equals</li>
            <li>notEquals</li>
            <li>contains</li>
            <li>notContains</li>
            <li>startsWith</li>
        </ul>
        <code>values</code> - array of string values to match for the rule type
    </td>
  </tr>
  <tr>
    <td>imagePath</td>
    <td>Containers running images matching paths. The path includes the registry, name and tag</td>
   <td>
        <code>operator</code> - conditional operator to apply to values
        <ul>
            <li>equals</li>
            <li>notEquals</li>
            <li>contains</li>
            <li>notContains</li>
            <li>startsWith</li>
        </ul>
        <code>values</code> - array of string values to match for the rule type
    </td>
  </tr>
  <tr>
    <td>imagesNotScanned</td>
    <td>Images that have not been scanned for one of vulnerability, malware or secrets in the given period</td>
    <td>
        <code>scanType</code> - Type of artifact scan
        <ul>
            <li>vulnerability</li>
            <li>malware</li>
            <li>secret</li>
        </ul>
        <code>maxScanAge</code> - Maximum age of the scan result in days (Integer value between 0 and 30 days)
    </td>
  </tr>
  <tr>
    <td>imagesWithMalware</td>
    <td>Images with malware</td>
    <td></td>
  </tr>
  <tr>
    <td>imagesWithSecrets</td>
    <td>Images with secrets</td>
    <td></td>
  </tr>
  <tr>
    <td>imagesWithVulnerabilities</td>
    <td>Images with vulnerabilities of severity or higher</td>
    <td>
        <code>severity</code> - severity of the vulnerability
        <ul>
            <li>critical</li>
            <li>high</li>
            <li>medium</li>
            <li>low</li>
            <li>any</li>
        </ul>
    </td>
  </tr>
  <tr>
    <td>imagesWithCVSSAttackVector</td>
    <td>Images with vulnerabilities with specific attack vector of severity or higher</td>
    <td>
        <code>severity</code> - severity of the vulnerability
        <ul>
            <li>critical</li>
            <li>high</li>
            <li>medium</li>
            <li>low</li>
            <li>any</li>
        </ul>
        <code>attackVector</code> - CVSS attack vector
        <ul>
            <li>network</li>
            <li>physical</li>
            <li>adjacent</li>
        </ul>
    </td>
  </tr>
  <tr>
    <td>imagesWithCVSSAttackComplexity</td>
    <td>Images with vulnerabilities with specific attack complexity of severity or higher</td>
    <td>
        <code>severity</code> - severity of the vulnerability
        <ul>
            <li>critical</li>
            <li>high</li>
            <li>medium</li>
            <li>low</li>
            <li>any</li>
        </ul>
        <code>attackComplexity</code> - CVSS attack complexity
        <ul>
            <li>low</li>
            <li>high</li>
        </ul>
    </td>
  </tr>
  <tr>
    <td>imagesWithCVSSAvailabilityImpact</td>
    <td>Images with vulnerabilities with specific availability impacts of severity or higher</td>
    <td>
        <code>severity</code> - severity of the vulnerability
        <ul>
            <li>critical</li>
            <li>high</li>
            <li>medium</li>
            <li>low</li>
            <li>any</li>
        </ul>
        <code>availabilityImpact</code> - CVSS availability impact
        <ul>
            <li>low</li>
            <li>high</li>
        </ul>
    </td>
  </tr>
</table>

### Sample ClusterPolicy Custom Resource

You can find a sample `ClusterPolicy` custom resource in [sample/clusterpolicy.yaml](../sample/clusterpolicy.yaml).

To create the policy, apply the custom resource yaml:

```shell
kubectl apply -f clusterpolicy.yaml
```


## Runtime Ruleset Custom Resource

The Runtime Ruleset defines the rules for runtime security. These Falco rules are managed by Trend Micro and referenced with the ruleID. The `RuntimeRuleset` spec contains the runtime definition with two fields: labels and rules.

- **labels**: array of pod labels to which the rules are applied using label selectors. Without the labels the rules are applied to all pods
  - **key**: label key
  - **value**: label value
- **rules**: array of rule IDs and mitigation to apply when the rule is triggered
  - **ruleID**: The Trend Micro runtime ruleID as `TM-{8 digit id}` (example: TM-00000001) - [List of available rules](https://docs.trendmicro.com/en-us/documentation/article/trend-vision-one-predefined-rules)
  - **mitigation**: Action to take on rule match (one of: `log`, `terminate`, or `isolate`)

### Sample RuntimeRuleset Custom Resource

You can find a sample `RuntimeRuleset` custom resource in [sample/runtimeruleset.yaml](../sample/runtimeruleset.yaml).

To create the runtime ruleset, apply the custom resource yaml:

```shell
kubectl apply -f runtimeruleset.yaml
```

## Understanding the Custom Resource Status

The policy operator will update the status of the custom resources to reflect the status of the policy resources in Vision One.

For the `ClusterPolicy` custom resource, the status will include the following fields:

- **Conditions**: An array of conditions of the following types:
  - **Parsed**: The policy has been parsed into a format that can be applied for enforcement
  - **Applied**: The policy has been created in Vision One
  - **Attached**: The policy has been assigned to the cluster
  - **Drifted**: The policy in Vision One has drifted from the custom resource spec
- **VisionOnePolicyID**: The ID of the policy in Vision One
- **VisionOneClusterID**: The ID of the cluster in Vision One

For the `RuntimeRuleset` custom resource, the status will include the following fields:

- **Conditions**: An array of conditions of the following types:
  - **Parsed**: The ruleset has been parsed into a format that can be applied for enforcement
  - **Applied**: The ruleset has been created in Vision One
  - **Attached**: The ruleset has been assigned to the policy
  - **Drifted**: The ruleset in Vision One has drifted from the custom resource spec
- **VisionOneRulesetID**: The ID of the ruleset in Vision One

To view the status of the custom resources, use the following command:

```shell
kubectl get clusterpolicy <name> -o json | jq .status
kubectl get runtimeruleset <name> -o json | jq .status
```

### Policy Parsing and Validation

The policy operator will parse the custom resources and validate the contents. If the policy or ruleset is invalid, the status condition **Parsed** will be updated to reflect the error. The policy operator will continue to create or update the resources but exclude the invalid rules.

See the **Message** field in the status condition **Parsed** for more information on parsing errors. The rule number and error details will be included in the message field for all invalid rules.

## Allow Drift from Custom Resource

By default, the policy operator will ensure that the policy and ruleset in Vision One match the custom resource spec. Vision One allows Security Admins to make temporary changes to cluster managed policies and their rulesets in the UI by enabling "allow drift" from the custom resource in Container Inventory UI.

To toggle allow drift settings, admins can update this setting on the cluster in the Vision One UI. The policy operator will respect the allow drift setting and will not attempt to reconcile the policy or ruleset if the allow drift setting is enabled. If the policy or ruleset in Vision One drifts from the custom resource spec, the status condition **Drifted** of the custom resource will be updated to reflect the drift. The contents of the policy and ruleset will not be updated to match the custom resource spec if the allow drift setting is enabled. If the custom resource is deleted, the resource in Vision One will also be deleted.

## Resource Cleanup

Ensure that the custom resources are deleted before disabling the policy operator or uninstalling the Trend Micro release. The policy operator will not delete the policy resources in Vision One when the operator is disabled or uninstalled.

After un-installing, if the policy resources owned by the cluster remain in Vision One, they will be deleted when the Cluster object that owns those resources are deleted.

## Custom Resource Finalizers

The policy operator will add a finalizer to the custom resources to ensure that the policy and ruleset are not deleted until the operator has removed the policy from Vision One. The finalizer will be removed once the policy has been deleted from Vision One.

If the policy operator is terminated before the finalizer is removed, the finalizer can be removed manually to allow the custom resource to be deleted. 

To remove the finalizer, edit the custom resource and remove the finalizer from the metadata section:

```yaml
metadata:
  finalizers:
  - clusterpolicy.visionone.trendmicro.com/finalizer
  - runtimeruleset.visionone.trendmicro.com/finalizer
```

The custom resource can also be patched to remove the finalizer:

```shell
kubectl patch clusterpolicy <name> -p '{"metadata":{"finalizers":null}}' --type=merge
```
