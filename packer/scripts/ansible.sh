#!/bin/bash -eux

# Install Ansible.
apt -y update && apt -y upgrade
apt -y install ansible
