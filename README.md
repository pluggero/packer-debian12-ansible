# Debian12 Packer Template for Ansible Role Testing

[![Build](https://github.com/pluggero/packer-debian12-ansible/actions/workflows/build.yml/badge.svg)](https://github.com/pluggero/packer-debian12-ansible/actions/workflows/build.yml)

## Supported Hypervisor Platforms

- VirtualBox

## Quick Start

### Requirements

- At least one of the supported Hypervisor platforms
- Vagrant

### Installation

- Take a look at https://portal.cloud.hashicorp.com/vagrant/discover/pluggero/debian12-ansible to get started with the Vagrant box.

## Creating your own box

1. Make sure you met the requirements above
2. Clone this repository
3. Create virtual python environment
4. Install dependencies
5. Run the build script to create the box in the `packer/outputs` directory:

```bash
scripts/debian12_builder.sh
```

## License

MIT / BSD

## Author Information

This role was created in 2025 by Robin Plugge.
