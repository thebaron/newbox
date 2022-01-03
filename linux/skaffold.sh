#! /usr/bin/env bash

set -e

# download the release
curl -L -o /tmp/skaffold "https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64" && sudo install /tmp/skaffold /usr/local/bin
