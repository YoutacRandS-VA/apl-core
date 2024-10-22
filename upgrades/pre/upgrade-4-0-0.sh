#!/bin/bash

set -eu

if [[ $(kubectl get applications.argoproj.io istio-system-istio-resources-artifacts -n argocd 2>/dev/null) ]]; then
  kubectl delete applications.argoproj.io istio-system-istio-resources-artifacts -n argocd
fi