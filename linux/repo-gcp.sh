#! /bin/sh

echo adding Google cloud repo
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-add-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main" 
