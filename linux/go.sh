#! /usr/bin/env bash

set -e

version=1.16.7 # latest stable version
arch=amd64

# download the release
curl -L -o /tmp/go.tar.gz "https://golang.org/dl/go${version}.linux-${arch}.tar.gz"

# extract the archive
cd /tmp
sudo tar -C /usr/local -zxvf go.tar.gz

