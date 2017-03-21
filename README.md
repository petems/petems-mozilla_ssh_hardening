# `petems-mozilla_ssh_hardening`

[![Build Status](https://travis-ci.org/petems/petems-mozilla_ssh_hardening.svg?branch=master)](https://travis-ci.org/petems/petems-mozilla_ssh_hardening)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mozilla_ssh_hardening](#setup)
    * [What mozilla_ssh_hardening affects](#what-mozilla_ssh_hardening-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mozilla_ssh_hardening](#beginning-with-mozilla_ssh_hardening)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Configures OpenSSH with [Mozilla hardening recomendations](https://wiki.mozilla.org/Security/Guidelines/OpenSSH).

## Module Description

This is a module to use an existing

It's basically my standard way of configuring and hardening SSH servers for my requirements, and is part of the base profile I configure on all my machines.

## Setup

### What `mozilla_ssh_hardening` affects

* All the standard stuff you expect from an `sshd` configuration, the config file, deamon, package and such
* Ciphers, MAC, Key exchanges are configured to be the Mozilla settings

### Setup Requirements

This module requires the `saz/ssh` module

### Beginning with `mozilla_ssh_hardening`

The most basic configuration is simply:

```puppet
include ::mozilla_ssh_hardening::server
```

There will be parameters to configure further settings as I do more research on SSH options.

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

## Limitations

Right now this is only extensively tested on the machines that I manage, which is mainly:

* Ubuntu 16.04
* CentOS 7
* CentOS 6

Other operating systems may work, if there are issues, pull-requests welcome!

Right now it's only setup to configure the server part of the setup, but I'm looking to extend it to support client in the future also.

## Development

If you'd like to other features or anything else, check out the contributing guidelines in [CONTRIBUTING.md](CONTRIBUTING.md).
