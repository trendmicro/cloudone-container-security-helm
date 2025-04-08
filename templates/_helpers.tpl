{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "container.security.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "container.security.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "container.security.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "container.security.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Admission Control Common labels
*/}}
{{- define "admissionController.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "admissionController.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Oversight Common labels
*/}}
{{- define "oversight.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "oversight.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Usage Controller Common labels
*/}}
{{- define "usage.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "usage.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Scan Manager Common labels
*/}}
{{- define "scanManager.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "scanManager.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Scout Common labels
*/}}
{{- define "scout.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "scout.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Workload Operator Common labels
*/}}
{{- define "workloadOperator.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "workloadOperator.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Scanner Common labels
*/}}
{{- define "scanner.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "scanner.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Compliance Scan Job Common labels
*/}}
{{- define "complianceScanJob.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "complianceScanJob.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Fargate Security Common labels
*/}}
{{- define "fargateInjector.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "fargateInjector.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
k8s-metacollector Common labels
*/}}
{{- define "k8sMetaCollector.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "k8sMetaCollector.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
malwareScanner Common labels
*/}}
{{- define "malwareScanner.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "malwareScanner.selectorLabels" . }}
{{- end }}

{{/*
Policy Operator Common Labels
*/}}
{{- define "policyOperator.labels" -}}
helm.sh/chart: {{ include "container.security.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "container.security.name" . }}
{{ include "policyOperator.selectorLabels" . }}
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Admission Control Selector labels
*/}}
{{- define "admissionController.selectorLabels" -}}
app.kubernetes.io/name: {{ include "admissionController.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-admission-controller
{{- end }}


{{/*
Oversight Selector labels
*/}}
{{- define "oversight.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oversight.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-oversight
{{- end }}

{{/*
Usage Controller Selector labels
*/}}
{{- define "usage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "usage.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-usage
{{- end }}

{{/*
Scan Manager Selector labels
*/}}
{{- define "scanManager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scanManager.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-scan-manager
{{- end }}

{{/*
Scout Controller Selector labels
*/}}
{{- define "scout.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scout.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-scout
{{- end }}

{{/*
Workload Operator Selector labels
*/}}
{{- define "workloadOperator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workloadOperator.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-workload-operator
{{- end }}

{{/*
Scanner Job Selector labels
*/}}
{{- define "scanner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scanner.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-scanner
{{- end }}

{{/*
Fargate Security Selector labels
*/}}
{{- define "fargateInjector.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fargateInjector.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-fargate-injector
{{- end }}

{{/*
k8s-metacollector Selector labels
*/}}
{{- define "k8sMetaCollector.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8sMetaCollector.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-k8s-metacollector
{{- end }}

{{/*
Policy Operator Selector labels
*/}}
{{- define "policyOperator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "policyOperator.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-policy-operator
{{- end }}

{{/*
Compliance Scan Job Selector labels
*/}}
{{- define "complianceScanJob.selectorLabels" -}}
app.kubernetes.io/name: compliance-scan-job
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-compliance-scan-job
{{- end }}

{{/*
Malware Scanner Selector labels
*/}}
{{- define "malwareScanner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "malwareScanner.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: trendmicro-malware-scanner
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "container.security.fullname" -}}
{{- if .Values.containerSecurityFullnameOverride -}}
{{- .Values.containerSecurityFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.containerSecurityNameOverride -}}
{{- if contains "trendmicro" $name -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" "trendmicro" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "admissionController.fullname" -}}
{{- if .Values.admissionControllerFullnameOverride -}}
{{- .Values.admissionControllerFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.admissionContollerNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "admission-controller" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "admission-controller" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "admission-controller" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "runtimeSecurity.fullname" -}}
{{- if .Values.runtimeSecurityFullnameOverride -}}
{{- .Values.runtimeSecurityFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.runtimeSecurityNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "runtime-protection" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "runtime-protection" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "runtime-protection" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oversight.fullname" -}}
{{- if .Values.oversightFullnameOverride -}}
{{- .Values.oversightFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.oversightFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "oversight" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "oversight" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "oversight" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "usage.fullname" -}}
{{- if .Values.usageFullnameOverride -}}
{{- .Values.usageFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.usageFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "usage" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "usage" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "usage" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scanManager.fullname" -}}
{{- if .Values.scanManagerFullnameOverride -}}
{{- .Values.scanManagerFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.scanManagerFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "scan-manager" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "scan-manager" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "scan-manager" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scout.fullname" -}}
{{- if .Values.scoutFullnameOverride -}}
{{- .Values.scoutFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.scoutFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "scout" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "scout" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "scout" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workloadOperator.fullname" -}}
{{- if .Values.workloadOperatorFullnameOverride -}}
{{- .Values.workloadOperatorFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.workloadOperatorFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "workload-operator" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "workload-operator" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "workload-operator" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scanner.fullname" -}}
{{- if .Values.scannerFullnameOverride -}}
{{- .Values.scannerFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.scannerFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "scanner" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "scanner" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "scanner" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "complianceScanner.fullname" -}}
{{- if .Values.complianceScannerFullnameOverride -}}
{{- .Values.complianceScannerFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.complianceScannerFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "compliance-scanner" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "compliance-scanner" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "compliance-scanner" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fargateInjector.fullname" -}}
{{- if .Values.fargateInjectorFullnameOverride -}}
{{- .Values.fargateInjectorFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.fargateInjectorNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "fargate-injector" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "fargate-injector" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "fargate-injector" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8sMetaCollector.fullname" -}}
{{- if .Values.k8sMetacollectorFullnameOverride -}}
{{- .Values.k8sMetacollectorFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.k8sMetacollectorFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "k8s-metacollector" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "k8s-metacollector" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "k8s-metacollector" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "policyOperator.fullname" -}}
{{- if .Values.policyOperatorFullnameOverride -}}
{{- .Values.policyOperatorFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.policyOperatorFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "policy-operator" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "policy-operator" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "policy-operator" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeRbacProxy.fullname" -}}
{{- if .Values.kubeRbacProxyFullnameOverride -}}
{{- .Values.kubeRbacProxyFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.kubeRbacProxyNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "kube-rbac-proxy" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "kube-rbac-proxy" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "kube-rbac-proxy" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "malwareScanner.fullname" -}}
{{- if .Values.malwareScannerFullnameOverride -}}
{{- .Values.malwareScannerFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.malwareScannerFullnameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "malware-scanner" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else if contains .Release.Name $name -}}
{{- printf "%s-%s" "malware-scanner" $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "malware-scanner" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Service name of k8s-metacollector
*/}}
{{- define "k8sMetaCollector.svc.url" -}}
{{- printf "%s.%s.svc.cluster.local:45000" (include "k8sMetaCollector.fullname" .) .Release.Namespace -}}
{{- end -}}

{{/*
Service name of malware scanner
*/}}
{{- define "malwareScanner.svc" -}}
{{- printf "trendmicro-malware-scanner" -}}
{{- end -}}

{{/*
Service url of malware scanner
*/}}
{{- define "malwareScanner.svc.url" -}}
{{- printf "%s.%s.svc.cluster.local" (include "malwareScanner.svc" .) .Release.Namespace -}}
{{- end -}}

{{/*
Create an image source.
*/}}
{{- define "image.source" -}}
{{- if and (not .registry) (not .imageDefaults.registry) -}}
{{- if .digest -}}
{{- printf "%s@%s" .repository .digest | quote -}}
{{- else -}}
{{- printf "%s:%s" .repository .tag | quote -}}
{{- end -}}
{{- else -}}
{{- if .digest -}}
{{- printf "%s/%s@%s" (default .imageDefaults.registry .registry) .repository .digest | quote -}}
{{- else -}}
{{- printf "%s/%s:%s" (default .imageDefaults.registry .registry) .repository .tag | quote -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Cloud One API Key auth
.Values.cloudOne.admissionController.apiKey is for backwards compatibility with the version <= v.1.0.1
*/}}
{{- define "container.security.auth.secret" -}}
{{- if not .Values.cloudOne.clusterRegistrationKey }}
{{- if not (and .Values.useExistingSecrets (eq true .Values.useExistingSecrets.containerSecurityAuth)) }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ template "container.security.fullname" . }}-auth
  labels:
    {{- include "container.security.labels" . | nindent 4 }}
type: Opaque
data:
{{- if and (hasKey .Values.cloudOne "apiKey") (.Values.cloudOne.apiKey) }}
  api.key: {{ .Values.cloudOne.apiKey | toString | b64enc | quote }}
{{- else if and (hasKey .Values.cloudOne.admissionController "apiKey") (.Values.cloudOne.admissionController.apiKey) }}
  api.key: {{ .Values.cloudOne.admissionController.apiKey | toString | b64enc | quote }}
{{- else }}
  api.key: {{ required "A valid Cloud One apiKey is required" .Values.cloudOne.apiKey | toString | b64enc | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}{{/* define */}}

{{/*
Cloud One API endpoint
.Values.cloudOne.admissionController.endpoint is for backwards compatibility with the version <= v.1.0.1
*/}}
{{- define "container.security.endpoint" -}}
{{- if and (hasKey .Values.cloudOne.admissionController "endpoint") (.Values.cloudOne.admissionController.endpoint) }}
{{- .Values.cloudOne.admissionController.endpoint -}}
{{- else if and (hasKey .Values.cloudOne "endpoint") (.Values.cloudOne.endpoint) }}
{{- .Values.cloudOne.endpoint -}}
{{- else }}
{{- required "A valid Cloud One endpoint is required" .Values.cloudOne.endpoint -}}
{{- end }}
{{- end -}}{{/* define */}}

{{/*
Provide HTTP proxy environment variables
*/}}
{{- define "container.security.proxy.env" -}}
- name: _PROXY_CONFIG_CHECKSUM
  value: {{ include (print $.Template.BasePath "/outbound-proxy.yaml") . | sha256sum }}
- name: HTTP_PROXY
  valueFrom:
    configMapKeyRef:
      name: {{ template "container.security.name" . }}-outbound-proxy
      key: httpProxy
- name: HTTPS_PROXY
  valueFrom:
    configMapKeyRef:
      name: {{ template "container.security.name" . }}-outbound-proxy
      key: httpsProxy
- name: ALL_PROXY
  valueFrom:
    secretKeyRef:
      name: {{ template "container.security.name" . }}-outbound-proxy-credentials
      key: allProxy
- name: NO_PROXY
  valueFrom:
    configMapKeyRef:
      name: {{ template "container.security.name" . }}-outbound-proxy
      key: noProxy
- name: PROXY_USER
  valueFrom:
    secretKeyRef:
      name: {{ template "container.security.name" . }}-outbound-proxy-credentials
      key: username
- name: PROXY_PASS
  valueFrom:
    secretKeyRef:
      name: {{ template "container.security.name" . }}-outbound-proxy-credentials
      key: password
{{- end -}}{{/*define*/}}

{{/*
TLS configuration - TLS min version
*/}}
{{- define "tlsConfig.minTLSVersion" -}}
{{- if .minTLSVersion }}
{{- .minTLSVersion }}
{{- else }}
{{- "VersionTLS12" }}
{{- end }}
{{- end }}

{{/*
TLS configuration - TLS cipher suites
*/}}
{{- define "tlsConfig.cipherSuites" -}}
{{- if .cipherSuites }}
{{- join "," .cipherSuites }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}

{{/*
Admission Controller Service Account
*/}}
{{- define "admissionController.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "admissionController.fullname" .) .Values.serviceAccount.admissionController.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.admissionController.name }}
{{- end }}
{{- end }}

{{/*
Oversight service account
*/}}
{{- define "oversight.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oversight.fullname" .) .Values.serviceAccount.oversight.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.oversight.name }}
{{- end }}
{{- end }}

{{/*
Usage Controller service account
*/}}
{{- define "usage.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "usage.fullname" .) .Values.serviceAccount.usage.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.usage.name }}
{{- end }}
{{- end }}

{{/*
Scout Controller service account
*/}}
{{- define "scout.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "scout.fullname" .) .Values.serviceAccount.scout.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.scout.name }}
{{- end }}
{{- end }}

{{/*
Scan Manager service account
*/}}
{{- define "scanManager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "scanManager.fullname" .) .Values.serviceAccount.scanManager.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.scanManager.name }}
{{- end }}
{{- end }}

{{/*
Scan Job service account
*/}}
{{- define "scanJob.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "scanner.fullname" .) .Values.serviceAccount.scanJob.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.scanJob.name }}
{{- end }}
{{- end }}

{{/*
Compliance Scan Job service account
*/}}
{{- define "complianceScanJob.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "complianceScanner.fullname" .) .Values.serviceAccount.complianceScanJob.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.complianceScanJob.name }}
{{- end }}
{{- end }}

{{/*
Workload Operator service account
*/}}
{{- define "workloadOperator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "workloadOperator.fullname" .) .Values.serviceAccount.workloadOperator.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.workloadOperator.name }}
{{- end }}
{{- end }}

{{/*
Fargate Injector service account
*/}}
{{- define "fargateInjector.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fargateInjector.fullname" .) .Values.serviceAccount.fargateInjector.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.fargateInjector.name }}
{{- end }}
{{- end }}

{{/*
k8s-collector service account
*/}}
{{- define "k8sMetaCollector.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k8sMetaCollector.fullname" .) .Values.serviceAccount.k8sMetaCollector.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.k8sMetaCollector.name }}
{{- end }}
{{- end }}

{{/*
Malware Scanner service account
*/}}
{{- define "malwareScanner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "malwareScanner.fullname" .) .Values.serviceAccount.malwareScanner.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.malwareScanner.name }}
{{- end }}
{{- end }}

{{/*
Policy Operator service account
*/}}
{{- define "policyOperator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "policyOperator.fullname" .) .Values.serviceAccount.policyOperator.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.policyOperator.name }}
{{- end }}
{{- end }}

{{/*
RBAC proxy container
*/}}
{{- define "rbacProxy" -}}
name: rbac-proxy
{{- if and (.securityContext) (eq true .securityContext.enabled) }}
{{- $securityContext := default .securityContext.default .customSecurityContext }}
{{- $podSecurityContext := default .securityContext.default.pod $securityContext.pod }}
{{- $containerSecurityContext := default .securityContext.default.container $securityContext.container.rbacProxy }}
securityContext: {{- toYaml $containerSecurityContext | nindent 4 }}
{{- end }}{{/* if .securityContext.enabled */}}
{{- $imageDefaults := .images.defaults }}
{{- with .images.rbacProxy -}}
{{- $project := (default (default "trendmicrocloudone" $imageDefaults.project) .project) }}
{{- $repository := printf "%s/%s" $project (required ".repository is required!" .repository) }}
{{- $tag := (default $imageDefaults.tag .tag) }}
image: {{ include "image.source" (dict "repository" $repository "registry" .registry "tag" $tag "imageDefaults" $imageDefaults "digest" .digest) }}
imagePullPolicy: {{ default (default "Always" $imageDefaults.pullPolicy) .pullPolicy }}
{{- end }}{{/* with .images.rbacProxy */}}
args:
- --secure-listen-address=0.0.0.0:8443
- --upstream=http://127.0.0.1:8080/
- --tls-cert-file=/etc/rbac-proxy/certs/cert.pem
- --tls-private-key-file=/etc/rbac-proxy/certs/key.pem
- --tls-min-version={{ include "tlsConfig.minTLSVersion" .tlsConfig }}
- --tls-cipher-suites={{ include "tlsConfig.cipherSuites" .tlsConfig }}
ports:
- containerPort: 8443
  name: https
volumeMounts:
- name: rbac-proxy-certs
  mountPath: /etc/rbac-proxy/certs
  readOnly: true
resources: {{ toYaml (default .resources.defaults .resources.rbacProxy) | nindent 2 }}
{{- end -}}{{/* define */}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "kubeVersion" -}}
{{- $version := semver .Capabilities.KubeVersion.Version }}
{{- printf "%v.%v.%v" $version.Major $version.Minor $version.Patch -}}
{{- end -}}

{{/*
Return the logLevel for the component
*/}}
{{- define "logLevel" -}}
{{- $componentLogLevel := index . 0 }}
{{- $ctx := index . 1 }}
{{- if $ctx.Values.logConfig.logLevel }}
{{- $ctx.Values.logConfig.logLevel }}
{{- else if $componentLogLevel }}
{{- $componentLogLevel }}
{{- else }}
{{- "info" }}
{{- end }}
{{- end -}}

{{/*
Return the trusted images digest
*/}}
{{- define "digest" -}}
{{- $digest :=""}}
{{- range $image := .Values.images }}
{{- if $image.digest}}
{{- if $digest}}
{{- $digest = printf "%s,%s" $digest $image.digest}}
{{- else}}
{{- $digest = $image.digest}}
{{- end }}
{{- end }}
{{- end }}
{{- $digest}}
{{- end -}}

{{/*
Validate input for cluster registration from override file
*/}}
{{- define "validateClusterInput" -}}
{{- if and .Values.cloudOne.apiKey .Values.cloudOne.clusterRegistrationKey }}
{{- fail "Please do not specify the apiKey in the override file when using automated cluster registration" }}
{{- end }}
{{- if and (not .Values.cloudOne.groupId ) (.Values.cloudOne.clusterRegistrationKey) }}
{{- fail "Please specify the groupId in the override file when using automated cluster registration" }}
{{- end }}
{{- if and .Values.cloudOne.clusterName (gt (float64 (len .Values.cloudOne.clusterName)) 64.0) }}
{{- fail "The cluster name must be less than 64 characters" }}
{{- end }}
{{- if and .Values.cloudOne.clusterNamePrefix (gt (float64 (len .Values.cloudOne.clusterNamePrefix)) 16.0) }}
{{- fail "The cluster name prefix must be less than 16 characters" }}
{{- end }}
{{- end -}}

{{- define "falco.securityContext" -}}
{{- $falcosecurityContext := default .Values.securityContext.default.container .Values.securityContext.scout.falco -}}
{{- if .Values.scout.falco.least_privileged }}
  {{- $patch := dict -}}
  {{- $patch := set $patch "privileged" false -}}
  {{- $patch := set $patch "capabilities" (dict "add" (list "SYS_ADMIN" "SYS_RESOURCE" "SYS_PTRACE")) -}}
  {{- $falcosecurityContext := mergeOverwrite $falcosecurityContext $patch -}}
{{- end -}}
{{- toYaml $falcosecurityContext }}
{{- end -}}


{{/*
Return the arguments for container runtime's sockets
Usage:
{{ include "containerRuntime.sock.args" ( list "cri-arg-name" "path-prefix" .Values.scout.falco ) }}
*/}}
{{- define "containerRuntime.sock.args"  -}}
{{- $arg := index . 0 -}}
{{- $pathprefix := index . 1 -}}
{{- $context := index . 2 -}}
{{- if and $context.docker $context.docker.enabled }}
- --{{$arg}}
- {{$pathprefix}}/var/run/docker.sock
{{- end }}{{/* if */}}
{{- if and $context.cri $context.cri.enabled }}
- --{{$arg}}
- {{$pathprefix}}/run/cri/cri.sock
{{- end }}{{/* if */}}
{{- if and $context.dockershim $context.dockershim.enabled }}
- --{{$arg}}
- {{$pathprefix}}/run/dockershim.sock
{{- end }}{{/* if */}}
{{- if and $context.k0s $context.k0s.enabled }}
- --{{$arg}}
- {{$pathprefix}}/run/k0s/containerd.sock
{{- end }}{{/* if */}}
{{- if and $context.k3s $context.k3s.enabled }}
- --{{$arg}}
- {{$pathprefix}}/run/k3s/containerd/containerd.sock
{{- end }}{{/* if */}}
{{- end -}}

{{/*
Return the Falco arguments for container runtime's sockets
Usage:
{{ include "containerRuntime.sock.falco.args" .Values.scout.falco }}
*/}}
{{- define "containerRuntime.sock.falco.args" -}}
{{- if and .docker .docker.enabled }} 
- -o
- container_engines.cri.sockets[]=/var/run/docker.sock
{{- end }}{{/* if */}}
{{- if and .cri .cri.enabled }}
- -o
- container_engines.cri.sockets[]=/run/cri/cri.sock
{{- end }}{{/* if */}}
{{- if and .dockershim .dockershim.enabled }}
- -o
- container_engines.cri.sockets[]=/run/dockershim.sock
{{- end }}{{/* if */}}
{{- if and .k0s .k0s.enabled }}
- -o
- container_engines.cri.sockets[]=/run/k0s/containerd.sock
{{- end }}{{/* if */}}
{{- if and .k3s .k3s.enabled }}
- -o
- container_engines.cri.sockets[]=/run/k3s/containerd/containerd.sock
{{- end }}{{/* if */}}
{{- end -}}

{{/*
Return the volume mounts for container runtime's sockets
Usage:
{{ include "containerRuntime.sock.volumeMounts" ( list "path-prefix" .Values.scout.falco ) }}
*/}}
{{- define "containerRuntime.sock.volumeMounts" -}}
{{- $pathprefix := index . 0 -}}
{{- $context := index . 1 -}}
{{- if and $context.docker $context.docker.enabled }}
- mountPath: {{$pathprefix}}/var/run/docker.sock
  name: docker-socket
{{- end}}{{/* if */}}
{{- if and $context.cri $context.cri.enabled }}
- mountPath: {{$pathprefix}}/run/cri/cri.sock
  name: cri-socket
{{- end}}{{/* if */}}
{{- if and $context.dockershim $context.dockershim.enabled }}
- mountPath: {{$pathprefix}}/run/dockershim.sock
  name: dockershim-socket
{{- end}}{{/* if */}}
{{- if and $context.k0s $context.k0s.enabled }}
- mountPath: {{$pathprefix}}/run/k0s/containerd.sock
  name: k0s-socket
{{- end}}{{/* if */}}
{{- if and $context.k3s $context.k3s.enabled }}
- mountPath: {{$pathprefix}}/run/k3s/containerd/containerd.sock
  name: k3s-socket
{{- end}}{{/* if */}}
{{- end -}}

{{/*
Return the volume for container runtime's sockets
Usage:
{{ include "containerRuntime.sock.volumes" ( list $ .Values.scout.falco ) }}
*/}}
{{- define "containerRuntime.sock.volumes"  -}}
{{- $ := index . 0 -}}
{{- $context := index . 1 -}}
{{- if $context.docker.enabled }}
- name: docker-socket
  hostPath:
    path: {{ $context.docker.socket }}
{{- end}}{{/* if */}}
{{- if $context.cri.enabled }}
- name: cri-socket
  hostPath:
    # default is /run/crio/crio.sock on OpenShift.
    {{- $defaultcripath := "/run/containerd/containerd.sock" }}
    {{- if $.Capabilities.APIVersions.Has "security.openshift.io/v1" }}
    {{- $defaultcripath = "/run/crio/crio.sock" }}
    {{- end }}{{/* if */}}
    path: {{ $context.cri.socket | default $defaultcripath }}
{{- end }}{{/* if */}}
{{- if (and $context.dockershim $context.dockershim.enabled) }}
- name: dockershim-socket
  hostPath:
    # default is /run/dockershim.sock on bottlerocket.
    {{- $defaultdockershimpath := "/run/dockershim.sock" }}
    path: {{ $context.dockershim.socket | default $defaultdockershimpath }}
{{- end }}{{/* if */}}
{{- if (and $context.k0s $context.k0s.enabled) }}
- name: k0s-socket
  hostPath:
    {{- $defaultk0spath := "/run/k0s/containerd.sock" }}
    path: {{ $context.k0s.socket | default $defaultk0spath }}
{{- end }}{{/* if */}}
{{- if (and $context.k3s $context.k3s.enabled) }}
- name: k3s-socket
  hostPath:
    {{- $defaultk3spath := "/run/k3s/containerd/containerd.sock" }}
    path: {{ $context.k3s.socket | default $defaultk3spath }}
{{- end }}{{/* if */}}
{{- end -}}

{{/*
Check if the cloudOne.endpoint points to Vision One
*/}}
{{- define "container.security.isVisionOneEndpoint" -}}
{{- $endpoint := include "container.security.endpoint" . -}}
{{- if contains "trendmicro.com/external" $endpoint -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}


{{/*
Automatically adds any namespace with prefix to excluded namespace list for openshift
*/}}
{{- define "namespaceExclusions" -}}
{{- $excludedNamespaces := .Values.cloudOne.exclusion.namespaces | default list -}}
{{- $osNsPrefixes := .Values.cloudOne.exclusion.osNsPrefixes | default list -}}

{{- if .Capabilities.APIVersions.Has "security.openshift.io/v1" -}}
  {{- $namespaceList := lookup "v1" "Namespace" "" "" -}}
  {{- if $namespaceList -}}
    {{- range $index, $namespace := $namespaceList.items -}}
      {{- range $prefix := $osNsPrefixes -}}
        {{- if hasPrefix $prefix $namespace.metadata.name -}}
          {{- $excludedNamespaces = append $excludedNamespaces $namespace.metadata.name -}}
          {{- break -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- join "," $excludedNamespaces -}}
{{- end -}}

{{/* hec client command line arguments as env variable*/}}
{{- define "hec_client_params_as_env_var" -}}
  {{- printf "-v" -}}
  {{- with .url -}}{{- printf " -U \\\"%s\\\"" . -}}{{- end -}}
  {{- range .headers -}}{{- printf " -H \\\"%s\\\"" . -}}{{- end -}}
  {{- with .hecTokenSecretName -}}
    {{- printf " -H \\\"%s\\\"" "Authorization: Splunk $(echo ${SPLUNK_HEC_TOKEN})" -}}
  {{- end -}}
{{- end -}}