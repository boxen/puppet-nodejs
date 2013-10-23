# Public: Install the blessed release of nodejs v0.8.x
#
# Usage:
#
#   include nodejs::v0_8

class nodejs::v0_8 {
  require nodejs
  require nodejs::v0_8_26

  file { "${nodejs::nodenv_root}/versions/v0.8":
    ensure => link,
    owner  => $nodejs::nodenv_user,
    target => "${nodejs::nodenv_root}/versions/v0.8.26"
  }
}
