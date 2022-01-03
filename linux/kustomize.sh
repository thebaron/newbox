#! /usr/bin/env bash

set -e

version=4.4.0 # latest stable version
arch=amd64

# download the release
curl -L -o /tmp/kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${version}/kustomize_v${version}_linux_${arch}.tar.gz"

# extract the archive
cd /tmp
tar -zxvf kustomize.tar.gz
sudo install kustomize /usr/local/bin

