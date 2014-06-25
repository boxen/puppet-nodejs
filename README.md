# nodejs Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-nodejs.svg?branch=master)](https://travis-ci.org/boxen/puppet-nodejs)

Using nodenv for nodejs version management,
automates installation and configuration of nodejs versions.

## Usage

``` puppet
# include some provided versions
include nodejs::v0_10
include nodejs::v0_8_8

# install any arbitrary nodejs version
nodejs { 'v0.10.1': }

# set the global nodejs version
class { 'nodejs::global': version => 'v0.10.1' }

# install some npm modules
nodejs::module { 'bower':
  node_version => 'v0.10'
}
```

## Required Puppet Modules

* boxen ( OS X only ) > 2.1
* repository > 2.2
* stdlib >= 3.0.0

##### Latest supported Node.js version
v0.10.29
