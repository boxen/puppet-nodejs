# Public: Install the blessed release of nodejs v0.8.x
#
# Usage:
#
#   include nodejs::v0_8

class nodejs::v0_8 {
  include nodejs::config
  include nodejs::v0_8_8

  file { "${nodejs::config::root}/versions/v0.8":
    ensure => link,
    target => "${nodejs::config::root}/versions/v0.8.8"
  }
}

