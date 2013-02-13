# Node.js Puppet Module for Boxen

## Usage

```puppet
include nodejs::0-8

nodejs::local { $dir:
  version => '0.8'
}
```

## Required Puppet Modules

* boxen
* nvm
* stdlib
