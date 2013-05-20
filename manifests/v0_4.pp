# Public: Install the blessed release of nodejs v0.4.x
#
# Usage:
#
#   include nodejs::v0_4

class nodejs::v0_4 {
  require nodejs
  require nodejs::v0_4_10

  file { "${nodejs::nodenv_root}/versions/v0.4":
    ensure => link,
    owner  => $nodejs::nodenv_user,
    target => "${nodejs::nodenv_root}/versions/v0.4.10"
  }
}
