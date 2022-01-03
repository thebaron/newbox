#! /usr/bin/env bash

set -e


# Add repos

./repo-hashi.sh
./repo-gcp.sh

# install a bunch of stuff

sudo apt install -y \
             silversearcher-ag \
             aria2 \
             direnv \
             entr \
             fzf \
             gdb \
             gnupg \
             nodejs \
             p7zip \
             packer \
	     prettyping \
             pwgen \
             screen \
             sqlite \
             jp \
             docker.io \
	     docker-compose \
	     kubectl \
	     kubetail \
	     terraform \
	     cpu-checker \
             qemu-kvm \
	     libvirt-daemon-system \
	     libvirt-clients \
	     bridge-utils \
	     virt-manager 

# Install some python stuff
python3 -m pip install --user cookiecutter
