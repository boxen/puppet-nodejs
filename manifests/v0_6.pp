# Public: Install the blessed release of nodejs v0.6.x
#
# Usage:
#
#   include nodejs::v0_6

class nodejs::v0_6 {
  require nodejs
  require nodejs::v0_6_20

  file { "${nodejs::nodenv_root}/versions/v0.6":
    ensure => link,
    owner  => $nodejs::nodenv_user,
    target => "${nodejs::nodenv_root}/versions/v0.6.20"
  }
}
