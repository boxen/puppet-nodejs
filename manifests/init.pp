# Public: Install nodenv so nodejs versions can be installed
#
# Usage:
#
#   include nodejs

class nodejs {
  include boxen::config
  include nodejs::config
  include nodejs::rehash

  file {
    [$nodejs::config::root, "${nodejs::config::root}/versions"]:
      ensure => directory;
    "${boxen::config::envdir}/nodenv.sh":
      source => 'puppet:///modules/nodejs/nodenv.sh' ;
  }

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/wfarr/nodenv.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${nodejs::config::nodenv_version}"

  exec { 'nodenv-setup-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $nodejs::config::root,
    creates => "${nodejs::config::root}/bin/nodenv",
    require => [ File[$nodejs::config::root], Class['git'] ]
  }

  exec { "ensure-nodenv-version-${nodejs::config::nodenv_version}":
    command => "${git_fetch} && git reset --hard ${nodejs::config::nodenv_version}",
    unless  => "git describe --tags --exact-match `git rev-parse HEAD` | grep ${nodejs::config::nodenv_version}",
    cwd     => $nodejs::config::root,
    require => Exec['nodenv-setup-repo']
  }

  exec { 'purge nvm':
    command => "rm -rf ${boxen::config::home}/nvm",
    onlyif  => "test -d ${boxen::config::home}/nvm"
  }

  file { "${boxen::config::home}/env.d/nvm.sh":
    ensure => absent
  }
}
