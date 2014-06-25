# Public: Install the blessed release of nodejs v0.10.x
#
# Usage:
#
#   include nodejs::v0_10

class nodejs::v0_10 {
  require nodejs
  require nodejs::v0_10_29

  file { "${nodejs::nodenv_root}/versions/v0.10":
    ensure => link,
    owner  => $nodejs::nodenv_user,
    target => "${nodejs::nodenv_root}/versions/v0.10.29",
  }
}
