# Public: Install nodenv so nodejs versions can be installed
#
# Usage:
#
#   include nodejs

class nodejs(
  $nodenv_root    = $nodejs::params::nodenv_root,
  $nodenv_user    = $nodejs::params::nodenv_user,
  $nodenv_version = $nodejs::params::nodenv_version,

  $nvm_root       = $nodejs::params::nvm_root
) inherits nodejs::params {
  require nodejs::nvm
  include nodejs::rehash

  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/nodenv.sh":
      ensure => absent,
    }

    boxen::env_script { 'nodejs':
      priority => 'higher',
      source   => 'puppet:///modules/nodejs/nodenv.sh',
    }
  }

  repository { $nodenv_root:
    ensure => $nodenv_version,
    force  => true,
    source => 'wfarr/nodenv',
    user   => $nodenv_user
  }

  file { "${nodejs::nodenv_root}/versions":
    ensure  => directory,
    owner   => $nodenv_user,
    mode    => '0755',
    require => Repository[$nodenv_root]
  }
}
