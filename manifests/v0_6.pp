# Public: Install the blessed release of nodejs v0.6.x
#
# Usage:
#
#   include nodejs::v0_6

class nodejs::v0_6 {
  include nodejs::config
  include nodejs::v0_6_20

  file { "${nodejs::config::root}/versions/v0.6":
    ensure => link,
    target => "${nodejs::config::root}/versions/v0.6.20"
  }
}

