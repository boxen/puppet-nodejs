# Public: Install the blessed release of nodejs v0.10.x
#
# Usage:
#
#   include nodejs::v0_10

class nodejs::v0_10 {
  include nodejs::config
  include nodejs::v0_10_5

  file { "${nodejs::config::root}/versions/v0.10":
    ensure => link,
    target => "${nodejs::config::root}/versions/v0.10.5"
  }
}

