#! /bin/sh

echo 'Installing the AWS CLI tool (v2, current)'

set -o e

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "${HOME}/Downloads/AWSCLIV2.pkg"
sudo installer -pkg "${HOME}/Downloads/AWSCLIV2.pkg" -target /

echo Done.
