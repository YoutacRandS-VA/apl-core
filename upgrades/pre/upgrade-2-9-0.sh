#!/bin/bash

set -eu

if kubectl get crd | grep -q operators.coreos.com; then
  kubectl delete apiservices.apiregistration.k8s.io v1.packages.operators.coreos.com
  kubectl delete -f charts/operator-lifecycle-manager/crds
else
  echo "No OLM operators found. Skipping."
fi

if [[ $(helm status -n argocd argocd-operator-cr 2>/dev/null) ]]; then
  helm uninstall argocd-operator-cr -n argocd
  helm uninstall argocd-operator-artifacts -n argocd
  kubectl label --overwrite customresourcedefinitions.apiextensions.k8s.io "applications.argoproj.io" app.kubernetes.io/managed-by=Helm
  kubectl annotate customresourcedefinitions.apiextensions.k8s.io "applications.argoproj.io" meta.helm.sh/release-name=argocd meta.helm.sh/release-namespace=argocd
  kubectl label --overwrite customresourcedefinitions.apiextensions.k8s.io "applicationsets.argoproj.io" app.kubernetes.io/managed-by=Helm
  kubectl annotate customresourcedefinitions.apiextensions.k8s.io "applicationsets.argoproj.io" meta.helm.sh/release-name=argocd meta.helm.sh/release-namespace=argocd
  kubectl label --overwrite customresourcedefinitions.apiextensions.k8s.io "appprojects.argoproj.io" app.kubernetes.io/managed-by=Helm
  kubectl annotate customresourcedefinitions.apiextensions.k8s.io "appprojects.argoproj.io" meta.helm.sh/release-name=argocd meta.helm.sh/release-namespace=argocd
else
  echo "The argocd-operator-cr helm release not found. Skipping."
fi
