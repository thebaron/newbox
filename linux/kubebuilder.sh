#! /usr/bin/env bash

set -e

version=1.0.8 # latest stable version
arch=amd64

# download the release
curl -L -o /tmp/kubebuilder.tar.gz "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v${version}/kubebuilder_${version}_linux_${arch}.tar.gz"

# extract the archive
cd /tmp
tar -zxvf kubebuilder.tar.gz
mv kubebuilder_${version}_linux_${arch} kubebuilder && sudo mv kubebuilder /usr/local/

