# nodejs Puppet Module for Boxen

Using nodenv for nodejs version management,
automates installation and configuration of nodejs versions.

## Usage

``` puppet
# include some provided versions
include nodejs::v0_10
include nodejs::v0_8_8

# install any arbitrary nodejs version
nodejs { 'v0.10.1': }

# install some npm modules
nodejs::module { 'bower':
  nodejs_version => 'v0.10'
}
```

## Required Puppet Modules

* boxen
* stdlib
