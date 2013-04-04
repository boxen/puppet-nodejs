# Public: Install the blessed release of nodejs v0.4.x
#
# Usage:
#
#   include nodejs::v0_4

class nodejs::v0_4 {
  include nodejs::config
  include nodejs::v0_4_10

  file { "${nodejs::config::root}/versions/v0.4":
    ensure => link,
    target => "${nodejs::config::root}/versions/v0.4.10"
  }
}

