# nodejs Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-nodejs.svg?branch=master)](https://travis-ci.org/boxen/puppet-nodejs)

Using nodenv for nodejs version management,
automates installation and configuration of nodejs versions.

## Usage

``` puppet
# include short version aliases
nodejs::version { 'v0.10': }

# install any arbitrary nodejs version
nodejs::version { 'v0.10.1': }

# set the global nodejs version
class { 'nodejs::global': version => 'v0.10.1' }

# install some npm modules
nodejs::module { 'bower':
  node_version => 'v0.10'
}
```

## Hiera configuration

The following variables may be automatically overridden with Hiera:

``` yaml
---
# Version compile configuration, if not version is defined the default is false
# Yyou can define whether to compile from source or not based on long version
# and define short versions as a fallback if non long version is defined
"nodejs::version::compile":
  "v0.10": false
  "v0.4": true
  "v0.6.20" : true

# Version aliases, commonly used to bless a specific version
# Use the "deeper" merge strategy, as with nodejs::version::env
"nodejs::version::alias":
  "v0.10": "v0.10.31"
  "v0.8": "v0.8.26"
  "v0.6": "v0.6.20"
  "v0.4": "v0.4.10"

```

It is **required** that you include
[ripienaar/puppet-module-data](https://github.com/ripienaar/puppet-module-data)
in your boxen project, as this module now ships with many pre-defined versions
and aliases in the `data/` directory. With this module included, those
definitions will be automatically loaded, but can be overridden easily in your
own hierarchy.

You can also use JSON if your Hiera is configured for that.

## Required Puppet Modules

* boxen ( OS X only ) > 2.1
* repository > 2.2
* stdlib >= 3.0.0
* [ripienaar/puppet-module-data](https://github.com/ripienaar/puppet-module-data)
