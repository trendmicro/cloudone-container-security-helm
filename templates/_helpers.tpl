{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "admission.controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "admission.controller.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create name and version as used by the chart label.
*/}}
{{- define "admission.controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Image and pull policy */}}
{{- define "image" -}}
{{- $project := (default (default "trendmicro" .defaults.project) .image.project) }}
{{- $repository := printf "%s/%s" $project (required ".repository is required!" .image.repository) }}
{{- $tag := (default .defaults.tag .image.tag) }}
image: {{ include "image.source" (dict "repository" $repository "registry" .image.registry "tag" $tag "imageDefaults" .defaults "digest" .image.digest) }}
imagePullPolicy: {{ default (default "Always" .defaults.pullPolicy) .image.pullPolicy }}
{{- end -}}{{/* define image*/}}

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