# Node.js Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`

## Usage

```puppet
require nodejs::0-8

nodejs::local { $dir:
  version => '0.8'
}
```
