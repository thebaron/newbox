#! /bin/sh

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"

cd /tmp
unzip awscliv2.zip

sudo /tmp/aws/install
