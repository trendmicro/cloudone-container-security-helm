{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "admission.controller.name" -}}
{{- default .Chart.Name .Values.admissionContollerNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "admission.controller.fullname" -}}
{{- if .Values.admissionControllerFullnameOverride -}}
{{- .Values.admissionControllerFullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.admissionContollerNameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" "admission-controller" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "admission-controller" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "runtimeSecurity.name" -}}
{{- default .Chart.Name .Values.runtimeSecurityNameOverride | trunc 63 | trimSuffix "-" -}}
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
{{- printf "%s-%s" "runtime-security" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" "runtime-security" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create an image source.
*/}}
{{- define "image.source" -}}
{{- if or (eq (default "" .registry) "-") (eq (default "-" .imageDefaults.registry) "-") -}}
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

{{- define "admission.controller.auth.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ template "admission.controller.fullname" . }}-auth
  labels:
    app: {{ template "admission.controller.name" . }}
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
    {{ $k }}: {{ quote $v }}
{{- end }}
type: Opaque
data:
  apiKey: {{ required "A valid Cloud One api-key is required" .Values.cloudOne.admissionController.apiKey | toString | b64enc | quote }}
{{- end -}}{{/* define */}}

{{- define "runtimeSecurity.credentials.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ template "runtimeSecurity.fullname" . }}-credentials
  labels:
    app: {{ template "runtimeSecurity.name" . }}
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
{{- range $k, $v := (default (dict) .Values.extraLabels) }}
    {{ $k }}: {{ quote $v }}
{{- end }}
type: Opaque
data:
  apiKey: {{ required "A valid runtime security api-key is required" .Values.cloudOne.runtimeSecurity.apiKey | toString | b64enc | quote }}
  secret: {{ required "A valid runtime security secret is required" .Values.cloudOne.runtimeSecurity.secret | toString | b64enc | quote }}
{{- end -}}{{/* define */}}