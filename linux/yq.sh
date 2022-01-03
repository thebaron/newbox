#! /usr/bin/env bash

set -e

version=4.13.5
arch=amd64

# download the release
curl -L -o /tmp/yq "https://github.com/mikefarah/yq/releases/download/v${version}/yq_linux_${arch}"

# extract the archive
cd /tmp
sudo install yq /usr/local/bin
