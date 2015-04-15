# Public: specify the global node version (only for nodenv)
#
# Usage:
#
#   class { 'nodejs::global': version => '0.10.36' }

class nodejs::global($version = '0.10.36') {
  require nodejs

  if $nodejs::provider == 'nodenv' {
    if $version != 'system' {
      ensure_resource('nodejs::version', $version)
      $require = Nodejs::Version[$version]
    } else {
      $require = undef
    }

    file { "${nodejs::nodenv::prefix}/version":
      ensure  => present,
      owner   => $nodejs::user,
      mode    => '0644',
      content => "${version}\n",
      require => $require,
    }
  }
}
