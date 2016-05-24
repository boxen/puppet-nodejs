# Public: Install an nodenv plugin
#
# Usage:
#
#   nodejs::nodenv::plugin { 'nodenv-vars':
#     ensure => 'ee42cd9db3f3fca2a77862ae05a410947c33ba09',
#     source => 'nodenv/nodenv-vars'
#   }

define nodejs::nodenv::plugin($ensure, $source) {
  require nodejs

  if $nodejs::provider == 'nodenv' {

    $plugins_dir_params =  {
      ensure  => directory,
      require => Repository[$nodejs::nodenv::prefix]
    }
    ensure_resource('file', "${nodejs::nodenv::prefix}/plugins", $plugins_dir_params)

    repository { "${nodejs::nodenv::prefix}/plugins/${name}":
      ensure  => $ensure,
      force   => true,
      source  => $source,
      user    => $nodejs::user,
      require => File["${nodejs::nodenv::prefix}/plugins"]
    }
  }
}
